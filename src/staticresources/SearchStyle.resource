/* CSS Style sheet used for the search page */


/* ----------------------------------------------- */
/* Flip Effects */
/* ----------------------------------------------- */

/* entire container, keeps perspective */
.flip-container {
    perspective: 1000px;
    margin: 10px 11px;
}

/* flip the pane when hovered */
.flip-container:hover .flipper, .flip-container.hover .flipper {
    transform: rotateY(180deg);
}

.flip-container, .front, .back {
    width: 203px;
    height: 300px;
    display: inline-block;
    border-radius: 10px;
}

/* flip speed goes here */
.flipper {
    transition: 0.6s;
    transform-style: preserve-3d;
    position: relative;
}

/* hide back of pane during swap */
.front, .back {
    backface-visibility: hidden;
    position: absolute;
    top: 0;
    left: 0;
}

/* front pane, placed above back */
.front {
    z-index: 2;
    /* for firefox 31 */
    transform: rotateY(0deg);
}

/* back, initially hidden pane */
.back {
    transform: rotateY(180deg);
}
/* ----------------------------------------------- */
/* Movie Information Next to Poster */
/* ----------------------------------------------- */
.adjacent-info{
	padding-right: 40px;
	padding-bottom: 100px;
	background:rgba(242,182,50,0.5);
	margin: 5px 5px -125px 220px ; 
	//margin-left: 220px;
	//margin-bottom: -125px;
	//margin-top: 5px;
}
h1{
	color: red;
}
.info-container{
	padding-top: 390px;
}
.home-section{
	background-color: rgb(154,51,52);
}