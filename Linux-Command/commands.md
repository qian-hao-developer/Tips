# compare file or folder
diff <-r> file1 file2
※ -u: git diff format / -c: relate content display

# search file content
grep <-r> "fastboot_menu" .

-r: search include directory
""内に*が検索文字として扱われる

# grep exclude
grep -r --color --exclude-dir={custom,lib,scripts} --exclude={*.xml,error_log} "beta" .