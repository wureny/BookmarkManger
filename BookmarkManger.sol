// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BookmarkManger{

    struct Book {
	string  content;
	string  desc;
    string name;
}

struct Bookmark {
    Book[] allbooks;
	Label label;
	string name;
	uint256 booknums;
	bytes32 ownerprincipal;
	bytes32[] managers;
    string desc;
    //uid=princiapl+id
    string uid;
    uint256 id;
    uint256 stars;
    uint256 managernums;
}

//uid=>bookmark
mapping(string=>Bookmark) public findbookmark;

struct User{
	bytes32 principal;
	Bookmark[] bookmarks;
    uint256 bookmarknums;
	uint256 booknums;
	Star[] stars;
}

enum Label {LabelA, LabelB, LabelC}

struct Star{
	string uid;
string desc;
}

uint256 public MAX_BOOKMARKS=20;
uint256 public MAX_BOOKS=1000;

bytes32 public contractowner;

uint256 public Usernums;
uint256 public Bookmarknums;
mapping(bytes32=>User) allusers;
mapping(string=>bool) isvalidbookmark;
mapping(bytes32=>bool) isvaliduser;
mapping(bytes32=>mapping(string=>bool)) isstared;
mapping(string=>mapping(bytes32=>bool)) ismanager;

constructor(uint256 maxbookmarks,uint256 maxbooks,bytes32 owner) {
    MAX_BOOKMARKS=maxbookmarks;
    MAX_BOOKS=maxbooks;
    contractowner=owner;
    Usernums=0;
    Bookmarknums=0;
}

event Adduser(bytes32 indexed user);

event Addbook(bytes32 indexed user,string bookname,string bookmarkid);

event Rmbook(bytes32 indexed user,string bookname,string bookmarkid);

event Changebookdesc(bytes32 indexed user,uint256 indexed bookid);

event Addbookmark(bytes32 indexed user,string bookmarkuid);

event Changebookmarkdesc(bytes32 indexed user,string bookmarkuid);

event Addstar(bytes32 indexed user,string bookmarkuid);

event Rmstar(bytes32 indexed user,string bookmarkuid);

event Addmanager(bytes32 indexed user,bytes32 indexed manager,string bookmarkuid);

event Rmmanager(bytes32 indexed user,bytes32 indexed manager,string bookmarkuid);

event Addlabel(bytes32 indexed owner,string labelname);

event Adduser(bytes32 indexed owner,bytes32 indexed user);

Bookmark public empBookmark = Bookmark({
    allbooks: new Book[](0), // 空数组
    label: Label(0), // Label 是枚举类型，0 表示默认值
    name: "", // 空字符串
    booknums: 0,
    ownerprincipal: bytes32(0), // 空字节32
    managers: new bytes32[](0), // 空数组
    desc: "", // 空字符串
    uid: "", // 空字符串
    id: 0,
    stars: 0,
    managernums:0
});

//
function getbook(string memory bookmarkuid,uint256 bookid) public view returns(Book memory) {
    require(isvalidbookmark[bookmarkuid]==true,"invalid bookmarkuid");
    require(bookid<findbookmark[bookmarkuid].booknums,"wrong bookid!");
    return findbookmark[bookmarkuid].allbooks[bookid];
}


//
function getbookmark(string memory uid) public view returns(Bookmark memory) {
    if (bytes(findbookmark[uid].name).length==0) {
        return empBookmark;   
    }
   return findbookmark[uid];
}

//
function getuserbookmarks(bytes32 principal) public view returns(Bookmark[] memory) {
    return allusers[principal].bookmarks;
}

//
function addbook(bytes32 principal,string memory name,string memory content,string memory desc,string memory bookmarkid) public returns(bool) {
    require(isvaliduser[principal]==true,"invalid user!");
    require(isvalidbookmark[bookmarkid]==true,"invalid bookmarkuid");
    Bookmark storage b=findbookmark[bookmarkid];
    uint256 tmp=0;
    for (uint i=0;i<b.managers.length;i++) {
        if (principal==b.managers[i]) {
            tmp=1;
            break;
        }
    }
    require(principal==findbookmark[bookmarkid].ownerprincipal||tmp==1,"You don't have the permission!");
    require(findbookmark[bookmarkid].allbooks.length<MAX_BOOKS,"Bookmark has reached maximum capacity");
    Book memory a=Book({
        content:content,
        desc:desc,
        name:name
    });
    findbookmark[bookmarkid].allbooks.push(a);
    emit Addbook(principal,name,bookmarkid);
    allusers[principal].booknums+=1;
    findbookmark[bookmarkid].booknums+=1;
    return true;
}

/*
function rmbook(bytes32 principal,uint256 id,string memory bookmarkid) public returns(bool) {
    require(isvalidbookmark[bookmarkid]==true,"invalid bookmarkuid"); 
    require(principal==findbookmark[bookmarkid].ownerprincipal,"You don't have the permission!");

 
}*/
//
function changebookdesc(bytes32 principal,string memory desc,uint256 bookid,string memory bookmarkuid) public returns(bool) {
    require(isvaliduser[principal]==true,"invalid user!");
    require(isvalidbookmark[bookmarkuid]==true,"invalid bookmarkuid");
        Bookmark memory b=findbookmark[bookmarkuid];
   uint256 tmp=0;
    for (uint i=0;i<b.managers.length;i++) {
        if (principal==b.managers[i]) {
            tmp=1;
            break;
        }
    }
    require(principal==findbookmark[bookmarkuid].ownerprincipal||tmp==1,"You don't have the permission!"); 
    require(bookid<b.booknums,"wrong bookid!");
    findbookmark[bookmarkuid].allbooks[bookid].desc=desc;
    emit Changebookdesc(principal,bookid);
    return true;
}

//
function addbookmark(bytes32 principal,Label label,string memory name,string memory desc) public returns(bool) {
    require(isvaliduser[principal]==true,"invalid user!");
    require(allusers[principal].bookmarknums<MAX_BOOKMARKS,"The number of Bookmarks has reached the maximum limit");
    require(bytes(findbookmark[name].name).length==0,"The name has exists");
    string memory uid=string.concat(string(abi.encodePacked(principal)),name);
    Bookmark memory b=Bookmark({
       allbooks:new Book[](0),
       label:label,
       name:name,
       booknums:0,
       ownerprincipal:principal,
       managers:new bytes32[](0),
       desc:desc,
       uid:uid,
       id:allusers[principal].bookmarknums,
       stars:0 ,
       managernums:0
    });
    allusers[principal].bookmarks.push(b);
    allusers[principal].bookmarknums+=1;
    emit Addbookmark(principal,uid);
    return true;
}

//
function changebookmarkdesc(bytes32 principal,string memory desc,string memory bookmarkuid) public returns(bool) {
    require(isvaliduser[principal]==true,"invalid user!");
    require(isvalidbookmark[bookmarkuid]==true,"invalid bookmarkuid"); 
    require(findbookmark[bookmarkuid].ownerprincipal==principal,"You don't have the permission!");
    findbookmark[bookmarkuid].desc=desc;
    emit Changebookmarkdesc(principal,bookmarkuid);
    return true;
}

//
function addstar(bytes32 principal,string memory bookmarkuid,string memory desc) public returns(bool) {
    require(isvaliduser[principal]==true,"invalid user!");
    require(isvalidbookmark[bookmarkuid]==true,"invalid bookmarkuid"); 
    require(isstared[principal][bookmarkuid]==false,"You have stared it!");
    isstared[principal][bookmarkuid]=true;
    Star memory s=Star({
        uid:bookmarkuid,
        desc:desc
    });
    allusers[principal].stars.push(s);
    findbookmark[bookmarkuid].stars+=1;
    emit Addstar(principal,bookmarkuid);
    return true;
}

//
function rmstart(bytes32 principal,string memory bookmarkuid) public returns(bool) {
    require(isvaliduser[principal]==true,"invalid user!");
    require(isvalidbookmark[bookmarkuid]==true,"invalid bookmarkuid"); 
    require(isstared[principal][bookmarkuid]==true,"You haven't stared it!");
    isstared[principal][bookmarkuid]=false;
    findbookmark[bookmarkuid].stars-=1;
    emit Rmstar(principal,bookmarkuid);
    return true;
}

//
function addmanger(bytes32 principal,bytes32 otherprincipal,string memory bookmarkuid) public returns(bool) {
    require(isvaliduser[principal]==true || isvaliduser[otherprincipal]==true,"invalid user!");
    require(isvalidbookmark[bookmarkuid]==true,"invalid bookmarkuid"); 
    require(ismanager[bookmarkuid][otherprincipal]==false,"Manager has existed!");
    findbookmark[bookmarkuid].managers.push(otherprincipal);
    ismanager[bookmarkuid][otherprincipal]=true;
    findbookmark[bookmarkuid].managernums+=1;
    emit Addmanager(principal,otherprincipal,bookmarkuid);
    return true;
}

//
function rmmanger(bytes32 principal,bytes32 otherprincipal,string memory bookmarkuid) public returns(bool) {
    require(isvaliduser[principal]==true || isvaliduser[otherprincipal]==true,"invalid user!");
    require(isvalidbookmark[bookmarkuid]==true,"invalid bookmarkuid"); 
    require(ismanager[bookmarkuid][otherprincipal]==true,"Manager doesn't existed!");
    ismanager[bookmarkuid][otherprincipal]=false;
    findbookmark[bookmarkuid].managernums-=1;
    emit Rmmanager(principal,otherprincipal,bookmarkuid);
    return true; 
}

//
/*
function addlabel(string labelname) public returns(bool) {}
 */

//
function adduser(bytes32 user) public returns(bool) {
    require(isvaliduser[user]==false,"user has existed!");
    User memory u=User({
        principal:bytes32(0),
        bookmarks: new Bookmark[](0),
        bookmarknums:0,
        booknums:0,
        stars:new Star[](0)
    });
    allusers[user]=u;
    emit Adduser(user);
    return true;
}

//
function getstars(bytes32 principal) public view returns (Bookmark[] memory)  {
    require(isvaliduser[principal]==true,"invalid user!"); 
    Bookmark[] memory ans1=new Bookmark[](allusers[principal].stars.length);
    uint256 len=0;
    for (uint256 i=0;i<allusers[principal].stars.length;i++) {
        if (isstared[principal][allusers[principal].stars[i].uid]==true) {
            ans1[len++]=findbookmark[allusers[principal].stars[i].uid];
        }
    }
    Bookmark[] memory ans=new Bookmark[](allusers[principal].stars.length);
    for(uint256 i=0;i<len;i++) {
        ans[i]=ans1[i];
    }
    return ans;
}

//
function getmanagers(bytes32 principal,string memory bookmarkuid) public view returns (User[] memory) {
    require(isvaliduser[principal]==true,"invalid user!");
    require(isvalidbookmark[bookmarkuid]==true,"invalid bookmarkuid");  
    User[] memory ans=new User[](findbookmark[bookmarkuid].managernums);
    uint256 t=0;
    for (uint256 i=0;i<findbookmark[bookmarkuid].managers.length;i++) {
        if (ismanager[bookmarkuid][findbookmark[bookmarkuid].managers[i]]==true) {
            ans[t++]=allusers[findbookmark[bookmarkuid].managers[i]];
       }
    }
    return ans;
}
}