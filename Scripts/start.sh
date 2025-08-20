# End-to-end automation script to start the Secure Photo Sharing App.
# 1. Resets generate_signed_url.py to placeholder.
# 2. Deploys infra + generates .env via deploy.sh.
# 3. Runs Flask backend (app.py).
# 4. Hosts frontend on http://localhost:8000.


#!/bin/bash

echo " Starting Secure Photo Sharing App..."

echo " Resetting generate_signed_url.py to placeholder..."
cp generate_signed_url_placeholder.py generate_signed_url.py

# Step 1: Deploy infra and generate .env + update CF domain
./deploy.sh

# Step 2: Run backend (Flask app)
echo " Launching backend (app.py)..."
python app.py &  # Run in background

# Step 3: Wait a few seconds for backend to be ready
sleep 3

# Step 4: Launch frontend (Python HTTP server)
echo " Hosting frontend on http://localhost:8000..."
cd frontend
python -m http.server 8000

