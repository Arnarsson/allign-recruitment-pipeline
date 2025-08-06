# Setup Instructions - ALLIGN Recruitment Pipeline

## Prerequisites

- Domain/hosting for HTML files
- n8n instance (self-hosted or cloud)
- OpenAI API key
- Email SMTP credentials
- MongoDB or PostgreSQL database
- Slack webhook (optional)
- Google OAuth (optional)

## Step 1: Deploy Application Form

### Option A: GitHub Pages (Free)

1. Fork this repository
2. Go to Settings → Pages
3. Source: Deploy from branch (main)
4. Your form will be available at:
   ```
   https://[your-username].github.io/allign-recruitment-pipeline/application-form.html
   ```

### Option B: Netlify (Professional)

1. Download the repository
2. Go to [netlify.com](https://netlify.com)
3. Drag the folder to deploy
4. Get instant URL like: `amazing-app-123.netlify.app`

### Option C: Your Own Server

1. Upload `application-form.html` to your web server
2. Access via your domain: `https://yourdomain.com/apply.html`

## Step 2: Configure Webhook

1. Open `application-form.html`
2. Find line 1436:
   ```javascript
   const response = await fetch('https://n8n.aigrowthadvisors.cc/webhook/allign-developer-application', {
   ```
3. Replace with your n8n webhook URL

## Step 3: Setup n8n Workflow

### 3.1 Import Workflow

1. Open your n8n instance
2. Click 'Workflows' → 'Import'
3. Select `n8n-workflow.json`
4. Click 'Import'

### 3.2 Configure Credentials

#### OpenAI (Required)
```
1. Go to Credentials → Add Credential → OpenAI
2. Add your API key: sk-...
3. Save
```

#### Email SMTP (Required)
```
1. Go to Credentials → Add Credential → Email (SMTP)
2. Configuration for Gmail:
   - Host: smtp.gmail.com
   - Port: 587
   - User: your-email@gmail.com
   - Password: App-specific password
   - SSL/TLS: Yes
3. Save
```

#### MongoDB (Required)
```
1. Go to Credentials → Add Credential → MongoDB
2. Connection String: mongodb://username:password@host:port/database
3. Save
```

#### Slack (Optional)
```
1. Go to Slack → Apps → Webhooks
2. Create webhook for your channel
3. Copy webhook URL
4. Add to n8n workflow
```

#### Google Calendar (Optional)
```
1. Go to Credentials → Add Credential → Google OAuth2
2. Follow OAuth setup process
3. Enable Calendar API
4. Save
```

### 3.3 Update Workflow Settings

1. **Email Addresses**:
   - Find all instances of `careers@allign.dk`
   - Replace with your email
   - Find `sven@allign.dk`
   - Replace with your email

2. **Company Info**:
   - Update company name if needed
   - Update location/timezone

3. **Webhook Path**:
   - Note your webhook URL
   - Format: `https://your-n8n.com/webhook/allign-developer-application`

### 3.4 Test Workflow

1. Click 'Execute Workflow'
2. Submit test application via form
3. Check execution logs
4. Verify email received
5. Check database entry

### 3.5 Activate Workflow

1. Toggle 'Active' switch
2. Workflow now runs automatically

## Step 4: Setup Admin Dashboard

1. Upload `screening-dashboard.html` to your server
2. Access at: `https://yourdomain.com/admin.html`
3. Bookmark for easy access

## Step 5: Configure Interview Guide

1. Save `interview-guide.html` locally
2. Open in browser when conducting interviews
3. Or host online for team access

## Step 6: Testing Checklist

- [ ] Submit test application
- [ ] Verify webhook receives data
- [ ] Check AI scoring works
- [ ] Confirm email sent to admin
- [ ] Confirm email sent to candidate
- [ ] Verify database storage
- [ ] Check Slack notification (if configured)
- [ ] Test calendar invite (for high scores)
- [ ] Review in admin dashboard
- [ ] Test interview guide timer

## Tracking & Analytics

### Add Tracking Parameters

```
LinkedIn: ?ref=linkedin
AngelList: ?ref=angellist
Indeed: ?ref=indeed
Direct: ?ref=direct
Specific: ?ref=person-name
```

### Example URLs

```
https://yourdomain.com/apply.html?ref=linkedin
https://yourdomain.com/apply.html?ref=stanislav
https://yourdomain.com/apply.html?ref=indeed-premium
```

## Environment Variables

Create `.env` file for n8n:

```bash
# Required
OPENAI_API_KEY=sk-...
MONGODB_URI=mongodb://...
SMTP_HOST=smtp.gmail.com
SMTP_USER=your-email@gmail.com
SMTP_PASS=app-password

# Optional
SLACK_WEBHOOK=https://hooks.slack.com/...
GOOGLE_CLIENT_ID=...
GOOGLE_CLIENT_SECRET=...
GITHUB_TOKEN=ghp_...
CLEARBIT_API_KEY=...
```

## Troubleshooting

### Form Not Submitting
- Check browser console for errors
- Verify webhook URL is correct
- Check CORS settings in n8n

### Webhook Not Receiving
- Verify n8n workflow is active
- Check webhook path matches
- Test with curl command

### Emails Not Sending
- Verify SMTP credentials
- Check spam folder
- Test SMTP connection

### Scoring Issues
- Check OpenAI API key
- Verify GPT-4 access
- Review function node code

## Security Considerations

1. **Use HTTPS** for all endpoints
2. **Limit webhook** to specific domains
3. **Rotate API keys** regularly
4. **Backup database** daily
5. **Monitor rate limits** on APIs
6. **Add reCAPTCHA** to prevent spam

## Maintenance

### Weekly
- Review failed executions
- Check API usage/costs
- Backup candidate data
- Review scoring accuracy

### Monthly
- Update scoring weights
- Optimize email templates
- Review conversion metrics
- Update interview questions

## Support

For issues or questions:
- Email: careers@allign.dk
- GitHub Issues: [Create Issue](https://github.com/Arnarsson/allign-recruitment-pipeline/issues)

---

*Setup time: 2-4 hours | Time saved weekly: 30+ hours*