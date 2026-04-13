# Cloud Function: openaiReply

This folder contains a Firebase Cloud Function that proxies prompts to OpenAI.

Usage:
1. Install dependencies:
   npm install

2. Set OpenAI API key securely. Two options:
   - Use environment config (not recommended for public repos):
     firebase functions:config:set openai.key="YOUR_API_KEY"
   - Use Firebase secrets (recommended):
     firebase functions:secrets:set OPENAI_API_KEY --data "YOUR_API_KEY"

3. Deploy the function:
   firebase deploy --only functions:openaiReply

4. After deploy, set `AppConstants.openAiFunctionUrl` in the Flutter app to the function URL returned by Firebase.

Security:
- Keep your API key out of the client. The function runs server-side and stores the key in env/config.
- Consider rate limiting and authentication to prevent abuse.

Notes:
- The function uses OpenAI Chat Completions API. Adjust model and parameters as needed.
