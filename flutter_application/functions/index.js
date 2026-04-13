const functions = require('firebase-functions');
const axios = require('axios');
const admin = require('firebase-admin');

try {
  admin.initializeApp();
} catch (e) {
  // already initialized
}

// Set OPENAI_API_KEY in Firebase environment: firebase functions:secrets or use functions.config
// Example using functions.config().openai.key or process.env.OPENAI_API_KEY

exports.openaiReply = functions.https.onRequest(async (req, res) => {
  if (req.method !== 'POST') return res.status(405).send({ error: 'Method not allowed' });

  const apiKey = process.env.OPENAI_API_KEY || (functions.config().openai && functions.config().openai.key);
  if (!apiKey) return res.status(500).send({ error: 'OpenAI API key not configured' });

  // Optional Firebase Auth token verification
  const authHeader = req.get('Authorization') || '';
  if (authHeader.startsWith('Bearer ')) {
    const idToken = authHeader.split('Bearer ')[1];
    try {
      await admin.auth().verifyIdToken(idToken);
    } catch (e) {
      return res.status(401).send({ error: 'Invalid Firebase ID token' });
    }
  }

  const prompt = req.body?.prompt;
  const history = req.body?.history; // optional array of messages
  if (!prompt && !history) return res.status(400).send({ error: 'Missing prompt or history' });

  const messages = Array.isArray(history) && history.length > 0
    ? history
    : [{ role: 'user', content: prompt }];

  try {
    const response = await axios.post('https://api.openai.com/v1/chat/completions', {
      model: 'gpt-4o-mini',
      messages: messages,
      max_tokens: 400,
    }, {
      headers: {
        'Authorization': `Bearer ${apiKey}`,
        'Content-Type': 'application/json'
      }
    });

    const reply = response.data?.choices?.[0]?.message?.content || '';
    return res.status(200).send({ reply });
  } catch (err) {
    console.error('OpenAI error', err?.response?.data || err.message || err);
    return res.status(500).send({ error: 'OpenAI request failed' });
  }
});
