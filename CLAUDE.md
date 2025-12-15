# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

ALLIGN Recruitment Pipeline is an AI-powered developer recruitment system that automates screening and initial interview processes. It combines a static HTML application form with n8n workflow automation for AI evaluation, scoring, and candidate routing.

## Architecture

### Components

1. **Application Form** (`application-form.html`, `index.html`) - Static HTML form with embedded JavaScript that collects candidate data and submits to n8n webhook
2. **n8n Workflows** (`n8n-*.json`) - Automation pipelines handling AI evaluation, routing, notifications, and database storage
3. **PostgreSQL Database** - Stores applicant data and AI evaluation results (schema in `database-setup.sql`)

### Data Flow

```
Candidate Form Submission
    → n8n Webhook Trigger
    → GPT-4 AI Evaluation (scoring 0-100)
    → Smart Routing (5 paths based on score)
    → Parallel Actions: Email, Slack, Database, Calendar
```

### Scoring System

Weighted criteria processed by GPT-4:
- Technical Skills: 35%
- AI Tools Proficiency: 20%
- Availability & Fit: 15%
- Culture & Motivation: 15%
- Portfolio Quality: 10%
- Communication: 5%

Routing thresholds:
- 85-100: FAST_TRACK (immediate interview)
- 70-84: INTERVIEW (48h scheduling)
- 55-69: TECHNICAL_TEST (coding assessment)
- 40-54: REVIEW (manual review)
- 0-39: REJECT (auto-rejection)

## Commands

This is a static site - no build process required.

### Testing

Test webhook integration:
```bash
curl -X POST YOUR_WEBHOOK_URL \
  -H "Content-Type: application/json" \
  -d @test-data.json
```

### Database Setup

Execute in PostgreSQL:
```bash
psql -h your-db-host -U your-username -d your-database-name -f database-setup.sql
```

### Deployment

**GitHub Pages**: Settings → Pages → Deploy from main branch

**Vercel**: Drag folder to deploy (uses `vercel.json` config)

**Netlify**: Drag folder for instant deployment

## Key Configuration Points

### Webhook URL

In `application-form.html` around line 1436, update:
```javascript
const response = await fetch('YOUR_WEBHOOK_URL', {
```

### n8n Workflow Configuration

When importing `n8n-allign-workflow.json`:
1. Update all instances of `careers@allign.dk` and `sven@allign.dk` to your emails
2. Configure credentials: OpenAI API, SMTP, PostgreSQL, Slack (optional), Google Calendar (optional)
3. Set webhook path to match form configuration

### Database Schema

Table: `applicants` (not `applications`) with columns for:
- Basic info: name, email, phone, location, linkedin_url, github_url
- Technical responses: react_experience, ai_tools_experience, portfolio_links
- AI results: ai_evaluation_json (JSONB), ai_overall_score (0-100), ai_recommendation

## Workflow Versions

Multiple n8n workflow JSON files exist for different configurations:
- `n8n-allign-workflow.json` - Original version
- `n8n-allign-workflow-v2-fixed.json` - Bug fixes applied
- `n8n-allign-workflow-v2-modern-fixed.json` - Modern n8n syntax
- `n8n-allign-workflow-v2-slack-fixed.json` - With Slack integration
- `n8n-allign-workflow-v2-unique-emails.json` - Handles duplicate email submissions

## Referral Tracking

URL parameters for source tracking:
```
?ref=linkedin
?ref=angellist
?ref=indeed
?ref=direct
?ref=person-name
```
