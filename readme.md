# Simple to Standard

Import your SimpleNote data into Standard Notes.

The normal Standard Notes import process from SimpleNote has some issues. The title is duplicated in the first line of every imported note, directly under the title field. It doesn't convert tags but includes them inline at the bottom of each note. It also drops creation and modification dates. Here's a quick attempt at throwing together a better version.

> ⚠ A word of caution: I don't know how to bulk delete notes short of deleting your account. You may want to try this out on an empty, unsynced account and make sure it's doing what you want if you're already an avid Standard Note user.
>
> It should go without saying that there's no warranty on this thing. Use at your own risk. I am not responsible for data loss. 

# How to
0. Install Ruby.
1. Open app.simplenote.com and sign in.
2. Click the hamburger button in the top left corner of the site
3. Click `Settings` at the bottom.
4. Click the `Tools` tab.
5. Click `Export Notes` and save `notes.zip`.
6. Open `notes.zip`. Within the archive is a folder named `source` containing `notes.json`.
7. Put `notes.json` in the same directory as this script.
8. Open a terminal and `cd` to the script directory.
9. Run `ruby simple-to-standard.rb` 
10. The script will generate `standardified-notes.json`.
11. Open app.standardnotes.org.
12. Click `Account` in the bottom left corner.
12. Click the `Decrypted` radio button.
13. Click `Import Backup`.
14. Be patient. Standard Notes may be unresponsive for a few dozen seconds if you've imported a decade worth of notes.
15. Enjoy!

The import does not include trashed notes. It will also totally import empty notes, so don't freak out if you see that. 😊

My personal instance of Standard Notes currently shows a count of 1087 next to "All notes", 1088 next to the "2020-09-22-import" tag this script generates, and 1106/1106 next to "notes and tags encrypted," so that's another thing to watch out for. Counting is hard. Maybe it's fine!
