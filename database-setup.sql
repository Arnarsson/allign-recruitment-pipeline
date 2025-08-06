-- ALLIGN Developer Application Database Setup
-- Run this SQL script in your PostgreSQL database before using the n8n workflow

-- Create the applicants table
CREATE TABLE IF NOT EXISTS applicants (
    id SERIAL PRIMARY KEY,
    
    -- Basic Information
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(50),
    location VARCHAR(255),
    linkedin_url TEXT,
    github_url TEXT,
    
    -- Technical Experience (JSON responses)
    react_experience TEXT,
    ai_tools_experience TEXT,
    portfolio_links TEXT,
    
    -- Availability & Commitment
    start_date VARCHAR(100),
    work_hours_timezone TEXT,
    remote_experience TEXT,
    
    -- Culture & Motivation
    why_allign TEXT,
    startup_experience TEXT,
    technical_challenge TEXT,
    
    -- Final Details
    salary_expectations VARCHAR(255),
    questions_for_us TEXT,
    additional_info TEXT,
    
    -- Application Metadata
    submitted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    referral_source VARCHAR(100) DEFAULT 'direct',
    user_agent TEXT,
    consent_given BOOLEAN DEFAULT FALSE,
    
    -- AI Evaluation Results (populated by n8n workflow)
    ai_evaluation_json JSONB,
    ai_overall_score INTEGER,
    ai_recommendation VARCHAR(50), -- 'fast_track', 'interview', 'technical_test', 'reject'
    ai_evaluation_summary TEXT,
    
    -- Processing Status
    status VARCHAR(50) DEFAULT 'submitted', -- 'submitted', 'ai_evaluated', 'interview_scheduled', 'rejected'
    processed_at TIMESTAMP WITH TIME ZONE,
    notes TEXT,
    
    -- Indexes for performance
    CONSTRAINT check_ai_score CHECK (ai_overall_score >= 0 AND ai_overall_score <= 100),
    CONSTRAINT check_recommendation CHECK (ai_recommendation IN ('fast_track', 'interview', 'technical_test', 'reject'))
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_applicants_email ON applicants(email);
CREATE INDEX IF NOT EXISTS idx_applicants_submitted_at ON applicants(submitted_at DESC);
CREATE INDEX IF NOT EXISTS idx_applicants_status ON applicants(status);
CREATE INDEX IF NOT EXISTS idx_applicants_ai_recommendation ON applicants(ai_recommendation);
CREATE INDEX IF NOT EXISTS idx_applicants_ai_score ON applicants(ai_overall_score DESC);

-- Create a view for easy reporting
CREATE OR REPLACE VIEW applicant_summary AS
SELECT 
    id,
    name,
    email,
    location,
    submitted_at,
    status,
    ai_overall_score,
    ai_recommendation,
    CASE 
        WHEN ai_overall_score >= 85 THEN 'Excellent'
        WHEN ai_overall_score >= 75 THEN 'Good'
        WHEN ai_overall_score >= 60 THEN 'Average'
        ELSE 'Below Average'
    END as score_category,
    EXTRACT(EPOCH FROM (NOW() - submitted_at)) / 3600 as hours_since_submission
FROM applicants
ORDER BY submitted_at DESC;

-- Grant permissions (adjust username as needed)
-- GRANT ALL PRIVILEGES ON TABLE applicants TO your_n8n_user;
-- GRANT ALL PRIVILEGES ON SEQUENCE applicants_id_seq TO your_n8n_user;
-- GRANT ALL PRIVILEGES ON TABLE applicant_summary TO your_n8n_user;

-- Sample query to verify setup
-- SELECT * FROM applicant_summary LIMIT 5;

COMMENT ON TABLE applicants IS 'Stores developer job applications for ALLIGN with AI evaluation results';
COMMENT ON COLUMN applicants.ai_evaluation_json IS 'Full JSON response from AI evaluation including detailed scoring';
COMMENT ON COLUMN applicants.ai_overall_score IS 'Overall score from 0-100 calculated by AI evaluation';
COMMENT ON COLUMN applicants.ai_recommendation IS 'AI recommendation: fast_track, interview, technical_test, or reject';