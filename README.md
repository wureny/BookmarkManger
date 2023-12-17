# BookmarkManger
## 基本功能

使用solidity在ICP上开发的收藏夹应用，每一位用户可以创建多个收藏夹，每一个收藏夹有名字，标签等属性，收藏夹中的收藏物有内容和资源描述两个属性，目前收藏夹全部公开，旨在更好地和他人分享。

用户可以搜索相关标签的收藏夹，也可以搜索其他用户地址，以更好的达到分享资源的目的。

用户甚至还可以收藏其他用户的收藏夹，所以收藏夹应该有一个唯一标识；

用户还可以授予其他用户管理员权限，可以增加内容；

bytes32类型的principal为用户唯一身份标识。

## 变量

```solidity
struct Book {
	string name;
	string public content;
	string public desc;
}

struct Bookmark {
	Book[] public books;
	Label  public label;
	string public name;
	uint256 public booknums;
	bytes32 public ownerprincipal;
	bytes32[] public mangers;
string desc;
uint256 id;
uint256 stars;
}

struct User{
	bytes32 public principal;
	Bookmarks[] public bookmarks;
	uint256 bookmarknums;
	uint256 booknums;
	Star[] stars;
}
struct Star{
	string uid;
string desc;
}

enum Label {LabelA, LabelB, LabelC}

uint256 public MAX_BOOKMARKS=20;
uint256 public MAX_BOOKS=1000;

bytes32 public contractowner;

uint256 public usernums;
uint256 public booknums;
mapping(bytes32=>User) allusers;

```

## 相关事件

```solidity
event Adduser(bytes32 indexed user)

event Addbook(bytes32 indexed user,string bookname,string bookmarkid)

event Rmbook(bytes32 indexed user,string bookname,string bookmarkid)

event Changebookdesc(bytes32 indexed user,uint256 indexed bookid)

event Addbookmark(bytes32 indexed user,string bookmarkuid)

event Changebookmarkdesc(bytes32 indexed user,string bookmarkuid)

event Addstar(bytes32 indexed user,string bookmarkuid)

event Rmstar(bytes32 indexed user,string bookmarkuid)

event Addmanager(bytes32 indexed user,bytes32 indexed manager,string bookmarkuid)

event Rmmanager(bytes32 indexed user,bytes32 indexed manager,string bookmarkuid)

event Addlabel(bytes32 indexed owner,string labelname)

event Adduser(bytes32 indexed owner,bytes32 indexed user)
```

## 相关函数

```solidity
constructor(uint256 maxbookmarks,uint256 maxbooks,bytes32 owner) {
}

//
function getbookmark(string uid) public returns(Bookmark) {}

//
function getuserbookmarks(bytes32 principal) public returns(Bookmark) {}

//
function addbook(string content,string desc,string bookmarkid) public returns(bool) {}

//
function rmbook(uint256 id,string bookmarkid) public returns(bool) {}

//
function changebookdesc(string desc,uint256 bookid) public returns(bool) {}

//
function addbookmark(Label label,string name,string desc) public returns(bool) {}

//
//function changebookmarkname(string name,uint256 bookmarkid) public returns(bool) {}

//
function changebookmarkdesc(string desc,uint256 bookmarkid) public returns(bool) {}

//
function addstar(string uid) public returns(bool) {}

//
function rmstart(string uid) public returns(bool) {}

//
function addmanger(bytes32 otherprincipal,string bookmarkid) public returns(bool) {}

//
function rmmanger(bytes32 otherprincipal,string bookmarkid) public returns(bool) {}

//
function addlabel(string labelname) public returns(bool) {}

//
function adduser(bytes32 user) public returns() {}

//
function getstars(bytes32 user) public returns (Bookmark[]) {}
```
