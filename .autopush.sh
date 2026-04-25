#!/bin/bash

# 1. Ensure SSH identity is loaded for the science account
echo "🔑 Loading SSH key for fsr-science..."
ssh-add ~/.ssh/id_ed25519_fsr_science

# 2. Initialize LFS if not already done
if ! git lfs install --skip-smudge > /dev/null 2>&1; then
    echo "📦 Initializing Git LFS..."
    git lfs install
fi

# 3. Track PDFs (this handles the .gitattributes)
git lfs track "*.pdf"
git add .gitattributes

# 4. Migrate history 
# This is crucial because your previous commits already failed due to size.
# It converts existing large files in your history to LFS pointers.
echo "🔄 Migrating large files to LFS pointers..."
git lfs migrate import --include="*.pdf" --everything --yes

# 5. Final Stage and Commit
echo "💾 Committing changes..."
git add .
git commit -m "feat: AutoPush with LFS tracking"

# 6. Force Push to overwrite the remote with local truth
echo "🚀 Force pushing to fsr-science..."
git push origin main --force

echo "✅ Done! Your science notebooks are now on GitHub."