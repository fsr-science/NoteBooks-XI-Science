#!/bin/bash

# Config
PDF_DIR="./NCERT-PDF"
NOTES_DIR="./AI-NOTES"

# Subjects to process
SUBJECTS=("BIOLOGY" "CHEMISTRY" "COMPUTER-SCIENCE" "MATHEMATICS" "PHYSICS")

# Suffixes for the 4 files to create per chapter
SUFFIXES=("NOTES" "GLOSSARY" "PQs" "REVISION_MINDMAPS")

# Keywords that indicate non-chapter PDFs to skip
SKIP_PATTERN="ANSWERS|APPENDIX|SUPPLEMENTARY"

created=0
skipped=0

for subject in "${SUBJECTS[@]}"; do
    pdf_subject_dir="$PDF_DIR/$subject"
    notes_subject_dir="$NOTES_DIR/$subject"

    # Find all chapter PDFs, exclude non-chapter files
    while IFS= read -r -d '' pdf_file; do
        filename=$(basename "$pdf_file" .pdf)

        # Skip ANSWERS, APPENDIX, SUPPLEMENTARY
        if echo "$filename" | grep -qE "$SKIP_PATTERN"; then
            continue
        fi

        chapter_dir="$notes_subject_dir/$filename"

        # Create chapter folder if it doesn't exist
        mkdir -p "$chapter_dir"

        # Create the 4 markdown files
        for suffix in "${SUFFIXES[@]}"; do
            md_file="$chapter_dir/${filename}-${suffix}.md"
            if [ ! -f "$md_file" ]; then
                touch "$md_file"
                echo "  [CREATED] $md_file"
                ((created++))
            else
                ((skipped++))
            fi
        done

    done < <(find "$pdf_subject_dir" -maxdepth 1 -name "*.pdf" -print0 | sort -z)
done

echo ""
echo "Done. Created: $created file(s), Skipped (already exist): $skipped file(s)."