// server.js
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const {
  ChimeSDKMeetingsClient,
  CreateMeetingCommand,
  CreateAttendeeCommand,
  GetMeetingCommand
} = require('@aws-sdk/client-chime-sdk-meetings');

// ----------------- AWS Config -----------------
const client = new ChimeSDKMeetingsClient({
  region: 'us-east-1',
  credentials: {
   accessKeyId: process.env.AWS_ACCESS_KEY_ID,
   secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
  },
});

// ----------------- Express App -----------------
const app = express();
app.use(cors());
app.use(bodyParser.json());

// ----------------- Keep a single meeting -----------------
let activeMeeting = null;

// ----------------- Store SDP offers temporarily -----------------
const sdpOffers = {}; // Keyed by attendeeId

// ----------------- Create Meeting + Attendee -----------------
app.post('/createMeeting', async (req, res) => {
  try {
    const { userId } = req.body;
    if (!userId) return res.status(400).json({ error: 'userId is required' });

    const safeUserId = userId.replace(/[^-_a-zA-Z0-9]/g, '');

    // 1️⃣ Check if activeMeeting exists on AWS
    if (activeMeeting) {
      try {
        const getMeetingCommand = new GetMeetingCommand({
          MeetingId: activeMeeting.MeetingId,
        });
        await client.send(getMeetingCommand);
        console.log('Reusing existing meeting:', activeMeeting.MeetingId);
      } catch (err) {
        console.log('Existing meeting not found, creating new one...');
        activeMeeting = null;
      }
    }

    // 2️⃣ Create new meeting if none exists
    if (!activeMeeting) {
      const clientRequestToken = `meeting-${Date.now()}`;
      const meetingCommand = new CreateMeetingCommand({
        ClientRequestToken: clientRequestToken,
        MediaRegion: 'us-east-1',
        ExternalMeetingId: `meeting-${safeUserId}-${Date.now()}`.slice(0, 64),
      });

      const meetingResponse = await client.send(meetingCommand);
      activeMeeting = meetingResponse.Meeting;
      console.log('Created new meeting:', activeMeeting.MeetingId);
    }

    // 3️⃣ Create unique attendee
    const attendeeCommand = new CreateAttendeeCommand({
      MeetingId: activeMeeting.MeetingId,
      ExternalUserId: `${safeUserId}-${Date.now()}`,
    });
    const attendeeResponse = await client.send(attendeeCommand);

    res.json({
      meeting: activeMeeting,
      attendee: attendeeResponse.Attendee,
    });
  } catch (err) {
    console.error('Error creating meeting:', err);
    res.status(500).json({ error: err.message });
  }
});

// ----------------- Receive Offer and return Answer -----------------
app.post('/receiveOffer', async (req, res) => {
  try {
    const { meetingId, attendeeId, sdp } = req.body;

    if (!meetingId || !attendeeId || !sdp) {
      return res.status(400).json({ error: 'meetingId, attendeeId, and sdp are required' });
    }

    // Store the offer temporarily
    sdpOffers[attendeeId] = sdp;
    console.log(`Received offer from attendee ${attendeeId}`);

    // For demo/testing: echo back the same SDP as answer (type 'answer')
    // In production, integrate with Chime SDK signaling to generate real answer
    const answerSdp = sdp;
    const answerType = 'answer';

    res.json({
      sdp: answerSdp,
      type: answerType,
    });
  } catch (err) {
    console.error('Error in /receiveOffer:', err);
    res.status(500).json({ error: err.message });
  }
});

// ----------------- Start Server -----------------
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Chime backend running on http://localhost:${PORT}`);
});
