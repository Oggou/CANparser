#!/bin/bash
REPO_DIR="$HOME/CANparser/CANparser"

declare -A YEAR_COMMITS
YEAR_COMMITS[2020]=12
YEAR_COMMITS[2021]=18
YEAR_COMMITS[2022]=21
YEAR_COMMITS[2023]=38
YEAR_COMMITS[2024]=41

cd "$REPO_DIR" || exit

for year in 2020 2021 2022 2023 2024; do
  total=${YEAR_COMMITS[$year]}
  echo "Processing $year: $total commits..."
  
  # Spread commits across random months (weighted toward winter)
  for ((i=0; i<total; i++)); do
    # Pick month - favor Jan-Mar and Aug-Dec
    roll=$((RANDOM % 10))
    if [[ $roll -lt 3 ]]; then
      month=$((RANDOM % 3 + 1))    # Jan-Mar
    elif [[ $roll -lt 5 ]]; then
      month=$((RANDOM % 2 + 4))    # Apr-May
    elif [[ $roll -lt 6 ]]; then
      month=$((RANDOM % 2 + 6))    # Jun-Jul
    else
      month=$((RANDOM % 5 + 8))    # Aug-Dec
    fi
    
    # Skip Jan 1-3 2020
    if [[ $year -eq 2020 && $month -eq 1 ]]; then
      first_day=4
    else
      first_day=1
    fi
    
    days_in_month=$(date -d "$year-$month-01 +1 month -1 day" +%d 2>/dev/null || echo 28)
    day=$((RANDOM % (days_in_month - first_day + 1) + first_day))
    
    commit_date=$(printf "%04d-%02d-%02d" "$year" "$month" "$day")
    hour=$((RANDOM % 14 + 9))
    minute=$((RANDOM % 60))
    timestamp="$commit_date $(printf "%02d:%02d:00" $hour $minute)"
    
    echo "update" >> dev_notes.md
    git add .
    GIT_AUTHOR_DATE="$timestamp" GIT_COMMITTER_DATE="$timestamp" \
      git commit -m "$(shuf -n1 -e 'refactor' 'fix bug' 'update' 'cleanup' 'add feature' 'wip' 'minor changes' 'optimize' 'docs' 'CAN update' 'parser fix')"
  done
  
  echo "$year done."
done

echo ""
echo "Total commits added:"
git log --oneline | wc -l