*{
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}
html{
    font-family:sans-serif;
    -ms-text-size-adjust:100%;
    -webkit-text-size-adjust:100%
}
a{
    background:transparent
}
a:link {
	text-decoration: none;
}
a:active,a:hover{
	text-decoration: none;
}
ul{
    list-style-type:none;
    line-height:1.4em;
}

header{
    position:fixed;
    top:0;
    left:0;
    background-color:#240606;
    width:100%;
    z-index:999
}
header a{
    color:#fff;
    font-weight:600
}

header>div.content{
    height:100px;
    margin:0 auto;
    width:1000px;
    display:-webkit-box;
    display:-moz-box;
    display:-ms-flexbox;
    display:-webkit-flex;
    display:flex;
    -webkit-align-items:center;
    -moz-align-items:center;
    -ms-align-items:center;
    -ms-flex-align:center;
    align-items:center;
    will-change:height
}
header.regular>div.content{
    animation:resizeToRegularHeader 0.2s linear;
    height:100px
}
header div.sub_media{
    position:relative;
    top:0;
    left:0
}
header div.sub_media div.left{
    max-width:60%
}

header.smaller>div.content{
    animation:resizeToSmallHeader 0.2s linear;
    height:64px
}
header.smaller ul{
    height:64px
}
header div.sub_media{
    position:relative;
    top:0;
    left:0
}
header div.sub_media div.right{
    max-width:40%
}
header ul{
    display:-webkit-box;
    display:-moz-box;
    display:-ms-flexbox;
    display:-webkit-flex;
    display:flex;
    -webkit-align-items:center;
    -moz-align-items:center;
    -ms-align-items:center;
    -ms-flex-align:center;
    align-items:center;
    font-size:1em;
    height:85px;
    box-sizing:border-box
}

header div.left ul.primary li{
    text-align:right;
    padding:10px 0
}
header ul.primary li.user a{
    display:block;
    padding:10px 0
}

header ul.left{
    justify-content:flex-start
}
header ul.right{
    justify-content:flex-end
}
header ul li span.glyphicons{
    top:2px
}
header div.left ul li{
    margin-right:30px;
    padding:0
}
header div.right li,header ul.right li{
    margin-left:30px
}
.backdrop {
    background-size: cover;
	background-position: center -50px;
	height: 100vh;
	//background-attachment: fixed;
	margin-top: 100px;
	repeat: no-repeat;
}
h1{
	font-size: 30px;
	color: white;
}
.movie-info h1, .stats h1{
	font-size: 26px;
	color: white;
	font-family: TiemposHeadlineWeb-Bold,Georgia,serif;
}
p{
	color: white;
	font-family: TiemposHeadlineWeb-Bold,Georgia,serif;
	font-size: 15px;
	line-height: 1.5;
}
.row{
	max-width: 1280px;
    margin: 0 auto;
}
.info-container{
	padding-top: 390px;
}
body{
	background-color: #240606;
}
.poster{
	border: 2px solid white;
}
stats{
	padding-top: 52px;
}
.stats p{
	padding-top: 15px;
}
.hide{
	display: none;
}
.movie-info p {
	padding-top: 15px;
	
	
}

.movie-info p:first-child {
	font-size: 15px;
}