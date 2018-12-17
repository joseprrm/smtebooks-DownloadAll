# smtebooks-DownloadAll

Lists with every link to a book avaliable in https://smtebooks.eu and the scripts to generate the lists are avaliable here. The scripts to download the files are still missing, but you can download most of the files with JDownloader (explanation below).

https://smtebooks.eu has two ways of storing the books, the old ones are in Google Drive and the new ones are in their own domain. 

The best way to download all the books in Google Drive is to feed the list to a download manager, such JDownloader, because the books are stored at Google Drive and it has a donwload limit, so it is useful to have a program that can pause downloads when the limit has been reached and resume them when you can start download again. The program that downloads the books has to know how to download from Google Drive, becouse the large files can't be downloaded with a simple petition. For example, aria2 doesn't know how to do it.

If you want to make a script to download the files, look at [gdown](https://github.com/wkentaro/gdown), a python module that knows how to download from Google Drive properly.

The best way to download the books stored in https://smtebooks.eu would be to make a script to download them, since most programs don't know how to download from websites protected with 'DDoS protection by Cloudflare'. This is still missing, I will try to implement it in the near future. 

You will see that in driveInfo.txt and driveLinks.txt, there are numbers that don't have a link in the line below. This is because the book is no longer avaliable. There are links that don't work anymore in the list.

Do not use the script smtebooks-DownloadAll.sh, since it is buggy and doesn't work. However, it may be useful to get ideas to write the scripts that download the books.

## Dependencies
- wget (install via your distro package manager)
- cfscrape (sudo pip install cfscrape)

## How to use
To generate the list with all the information of the google drive links:
    $ sh generateDriveInfo.sh
To just get the links:
    $ grep 'drive.google' driveInfo.txt > driveLinks.txt

To generate the list with all the information of the books stored in smtebooks.eu:
    $ sh generateSmtebooksInfo.sh
To just get the links:
    $ grep 'smtebooks.eu' smtebooksInfo.txt > smtebooksLinks.txt
