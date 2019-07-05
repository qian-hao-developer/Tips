# ${#array[*]}
# array[*] / array[@]

https://takuya-1st.hatenablog.jp/entry/2016/12/27/053456

${}内に、先頭から#をつけると、#の後ろにつける引数内容の長さを取得する
array[*]は、配列内容をIFS(連結記号)で一行に繋いで出力
そのため、${#array[*]}は、array配列の要素を一列に連結して、数を取得する
※array配列の数を取得
ちなみに、${#array}であれば、arrayが配列でも、array先頭内容の長さ(文字列であれば文字列の長さ)を取得する

i.e.
arr=("123" "12" "1234")
echo $arr
    -> 123
echo ${#arr}
    -> 3 (length of "123")
echo ${#arr[*]}
    -> 3 (count of arr)
