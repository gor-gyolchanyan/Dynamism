#!/bin/sh

# Store the working directory from which this script was launched.
original_working_directory="$(pwd)"

# If any command terminates with a non-zero exit code, this script terminates as well.
set -e

# The function to be called before this script terminates.
function on_exit {
	# Restore the working directory from which this script was launched.
	cd "${original_working_directory}"
}
trap on_exit EXIT

# Set the working directory to and store the path of the repository.
# This is achieved by assuming that this script is located at a specific path relative to the repository path.
cd "$(dirname "$(dirname "${0}")")"
repository_path="$(pwd)"

# Store the name of the repository.
# This is achieced by taking the base name of the repository path.
repository_name="$(basename "${repository_path}")"

# Store the path to the Xcode workspace.
xcode_workspace_path="${repository_name}.xcworkspace"

# Remove all ignored files from the working copy of the repository.
git clean -fdXq

# If the Xcode workspace is open then close and reopen it.
osascript <<EOF
tell application "Xcode"
	set saughtDocumentPath to (POSIX file "${repository_path}/${xcode_workspace_path}/")
	repeat with eachDocument in workspace documents
		set eachDocumentPath to (file of eachDocument)
		if eachDocumentPath is saughtDocumentPath then
			close eachDocument saving no
			tell application "Finder" to open saughtDocumentPath
			exit repeat
		end if
	end repeat
end tell
EOF
