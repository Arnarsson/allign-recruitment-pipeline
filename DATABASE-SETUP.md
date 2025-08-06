# Database Setup for ALLIGN n8n Workflow

## Quick Fix for "No Table Called Applicants" Error

The n8n workflow is failing because the PostgreSQL database doesn't have the required `applicants` table. Here's how to fix it:

## Step 1: Access Your PostgreSQL Database

Connect to your PostgreSQL database using one of these methods:

### Option A: psql Command Line
```bash
psql -h your-db-host -U your-username -d your-database-name
```

### Option B: pgAdmin Web Interface
1. Open pgAdmin in your browser
2. Connect to your PostgreSQL server
3. Navigate to your database
4. Open the Query Tool

### Option C: n8n PostgreSQL Node (Temporary)
1. Create a temporary PostgreSQL node in n8n
2. Set operation to "Execute Query"
3. Run the SQL setup script below

## Step 2: Run the Database Setup

Execute the SQL script from `database-setup.sql`:

```sql
-- Copy and paste the entire contents of database-setup.sql
-- Or run it directly:
\i /path/to/database-setup.sql
```

## Step 3: Verify the Setup

Check if the table was created successfully:

```sql
-- Check if table exists
\dt applicants

-- Check table structure
\d applicants

-- Test insert (this is what n8n will do)
SELECT COUNT(*) FROM applicants;
```

## Step 4: Update n8n PostgreSQL Connection

Make sure your n8n PostgreSQL node has:

1. **Correct connection details:**
   - Host: Your PostgreSQL server
   - Database: Database name where you created the table
   - User: Database user with INSERT/UPDATE permissions
   - Password: User password

2. **Correct table name:** `applicants` (lowercase)

3. **Correct operation:** `Insert` or `Upsert`

## Step 5: Test the Workflow

1. Submit a test application using the test controls (Ctrl+Shift+T → Submit Test)
2. Check n8n execution logs for any remaining errors
3. Verify data was inserted:

```sql
SELECT name, email, submitted_at, status FROM applicants ORDER BY submitted_at DESC LIMIT 5;
```

## Database Schema Overview

The `applicants` table includes:

- **Basic Info:** name, email, phone, location, LinkedIn, GitHub
- **Technical Responses:** All form questions and answers
- **AI Evaluation:** JSON results, score, recommendation
- **Processing:** Status tracking, notes, timestamps

## Common Issues & Solutions

### Issue: "Permission denied for table applicants"
**Solution:** Grant permissions to your n8n database user:
```sql
GRANT ALL PRIVILEGES ON TABLE applicants TO your_n8n_user;
GRANT ALL PRIVILEGES ON SEQUENCE applicants_id_seq TO your_n8n_user;
```

### Issue: "Column doesn't exist"
**Solution:** The n8n workflow might be referencing wrong column names. Check that your PostgreSQL node uses these exact field names:

- `name` (not `full_name`)
- `email` 
- `react_experience` (not `q1`)
- `ai_tools_experience` (not `q2`)
- etc.

### Issue: "Connection refused"
**Solution:** Verify PostgreSQL connection details in n8n:
- Correct host and port
- Database name exists
- User has connection permissions
- Network/firewall allows connections

## Testing the Database

After setup, you can run queries to monitor applications:

```sql
-- View recent applications
SELECT * FROM applicant_summary;

-- Count applications by status
SELECT status, COUNT(*) FROM applicants GROUP BY status;

-- View AI recommendations
SELECT ai_recommendation, AVG(ai_overall_score), COUNT(*) 
FROM applicants 
WHERE ai_recommendation IS NOT NULL 
GROUP BY ai_recommendation;
```

## Next Steps

1. Run the database setup script
2. Test with the form's test data
3. Check that data appears in the `applicants` table
4. Monitor the n8n workflow execution logs
5. If still having issues, check the specific PostgreSQL node configuration in n8n

The workflow should now work without the "no tables called applicants" error!