#!/bin/sh
#
# Configuration changes at lines:
#   25: The old email (git log) to find out.
#   26: Your new author name.
#   27: The new public email, we recommend your Github private email.
#       Which you can find @ https://github.com/settings/emails -> Keep my email addresses private -> in that text it says.
#

REPOSITORY="https://github.com/Hey/Change-Previous-Author" # Your repository to make the changes

# Get the current repository.
rm -rf ./ChangePreviousAuthor-temp
echo "\nCloning the repository.\n"
git clone $REPOSITORY --bare ChangePreviousAuthor-temp --quiet

# Go to the repository in question.
cd ChangePreviousAuthor-temp
git log

# Replacing all changes.
echo "\n\nReplacing all emails.\n"

git filter-branch --env-filter '
OLD_EMAIL="previous-email-found-in-git-log-command@noreply.github.com"
NEW_NAME="Hey"
NEW_EMAIL="18427051+Hey@users.noreply.github.com"
if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_COMMITTER_NAME="$NEW_NAME"
    export GIT_COMMITTER_EMAIL="$NEW_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_AUTHOR_NAME="$NEW_NAME"
    export GIT_AUTHOR_EMAIL="$NEW_EMAIL"
fi
' --tag-name-filter cat -- --branches --tags --quiet

# Push the changes.
sleep 3
echo "Pushing the changes.\n"
git push --force --tags origin 'refs/heads/*' --quiet

# Get out & Delete the temp file.
cd ../
rm -rf ./ChangePreviousAuthor-temp
