//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.18;

contract Twitter {


    uint16 public max_tweet_length = 280;


    //deifining our struct  

    struct Tweet{
        uint256 id;
        address author;
        string content;
        uint256 likes;
        uint256 timestamps;
    }

    mapping(address => Tweet[]) public tweets;

    address public owner;

    // creating events here

    event tweetcreated(uint256 id,address author,string content,uint256 timestamp);

    event tweetliked(address liker,address tweetauthor,uint256 tweetid,uint256 newlikecount);

    event tweetunliked(address unliker,address tweetauthor,uint256 tweetid,uint256 unlikecount);





    constructor(){
        owner=msg.sender;
    }

    //changing our tweet length by the owner only using modifiers

    modifier OnlyOwner(){
        require(msg.sender == owner,"YOU ARE NOT THE OWNER");
        _;
    }

    function changetweetlength(uint16 newtweetlength) public OnlyOwner {

        max_tweet_length=newtweetlength;

    }


    // struct defining

    function createTweet(string memory _tweet) public {

        require(bytes(_tweet).length <= max_tweet_length,"tweet is too long bro");

        Tweet memory newTweet = Tweet({
            id:tweets[msg.sender].length,      // here we defined what actually is id
            author:msg.sender,
            content:_tweet,
            timestamps: block.timestamp,
            likes:0
        });



        tweets[msg.sender].push(newTweet);

        emit tweetcreated(newTweet.id, newTweet.author, newTweet.content, newTweet.timestamps);
    }



    // like function

    function liketweet(address author,uint256 id) external  {
        require(tweets[author][id].id == id,"TWEET DOESNT EXISTS");
        tweets[author][id].likes++;

        emit tweetliked(msg.sender, author,id, tweets[author][id].likes);
    }

    function unliketweet(address author,uint256 id) external  {

        require(tweets[author][id].id==id,"NOPE");
        require(tweets[author][id].likes > 0,"NO LIKES TO DISLIKE");

        tweets[author][id].likes--;

        emit tweetunliked(msg.sender, author, id, tweets[author][id].likes);
    }





    // getting the tweets

    function getTweet(address _owner,uint _i) public view returns (Tweet memory){      // to get a single element from the tweet array 
        return tweets[_owner][_i]; 
    }

    function gettAllTweets(address _owner) public view returns (Tweet[] memory){       // to get all the tweets in the array 
        return tweets[_owner];  
    }


}
