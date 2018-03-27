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
	margin: 5px 5px -125px 220px;
}
h1{
	color: red;
}
.input-box {
    margin-left: 5px;
    border-radius: 5px;
    padding-top: 2px;
}
.save-button {
    float: right;
    text-decoration: none;
    display: inline-block;
    position: relative;
    padding: 5px 45px;
    background: #FE5F55;
    border: none;
    color: white;
    border-radius: 5px;
    transition: .2s;
}
.save-button:before,
.save-button:after {
    position: absolute;
    top: 0;
    bottom: 0;
    right: 0;
    padding-top: inherit;
    padding-bottom: inherit;
    width: 2.8em;
    content: "\01F50D";
    font-family: 'FontAwesome', sans-serif;
    text-align: center;
    transition: .2s;
    transform-origin: 50% 60%;
}

.save-button:before {
  background: rgba(0, 0, 0, 0.1);
}

.save-button:hover {
  background: #fe2f22;
  text-decoration: none;
  color: #fff;
}

.save-button:active,
.save-button:focus {
  background: #b90c01;
}

.save-button {
    min-width: 10em;
}