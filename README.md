# smtebooks-DownloadAll

# Important
This script doesn't work anymore. I will try to solve it in the next week.

# Description
This bash script downloads almost every book avaliable in https://smtebooks.us. 

It saves the books in directories named "0-99" (where the first 100 books should be) , "100-199" (the next 100) and so on. Many of the links are broken, so it will just download the available books.

There is a problem with the biggest files, since [smtebooks.us] use Google Drive, sometimes they can't be donwloaded, directly through wget. In this case, they have to be downloaded through a web browser. To know which files suffer from this problem, the temporary solution is to go to every folder that the script created and look for files whose name is just a number. Then open https://smtebooks.us/getfile/ followed by the number those files have in your browser. For example, if you find a file whose name is 1823, you should go to link https://smtebooks.us/getfile/1823.

## Dependencies
- wget

## To execute
Just run:

	$ sh smtebooks-DownloadAll.sh

## Things to improve
- It downloads the books one by one, it could be improved if it made several donwloads at a time.
- Fix the problem with the big files or make a script that opens all of theme in your browser.

