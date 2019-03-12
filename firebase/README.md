Setup

```bash
# Connect to firebase
npm install -g firebase-tools
firebase login
firebase use --add
# Chose correct project

# Download deps
cd functions
npm install
cd ..
```

Deploy

```bash
# Deploy
firebase deploy


✔  functions: Finished running predeploy script.
i  functions: ensuring necessary APIs are enabled...
✔  functions: all necessary APIs are enabled
i  functions: preparing functions directory for uploading...
i  functions: packaged functions (53.2 KB) for uploading
✔  functions: functions folder uploaded successfully
i  functions: updating Node.js 6 function sendYo(us-central1)...
✔  functions[sendYo(us-central1)]: Successful update operation. 

✔  Deploy complete!
```

Change `sendYo` function url in `FriendsModel.sendYo` to point to your firebase instance