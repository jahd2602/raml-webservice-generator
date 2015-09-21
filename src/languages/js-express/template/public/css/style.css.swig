 .output {
 	-webkit-touch-callout: none;
	-webkit-user-select: none;
	-khtml-user-select: none;
	-moz-user-select: none;
	-ms-user-select: none;
	user-select: none;
}

.btn {
	margin:2px;
}

.editBox  {
	width:65%;
}

.main {
    padding:10px;
    border:1px solid black;
    border-radius: 10px;
    box-shadow: 1px 1px 5px rgba(0, 0, 0, 0.4);
    text-align: center;
    width:80%;
}

@media (max-width: 500px) {
    .nav, .message, .editBox, .main {
        font-size:14px;
        font-weight: normal;
    }
    .main {
        width:80%;
        margin:auto;
    }
}

@media (min-width: 501px) and (max-width: 991px) {
    .nav, .message, .editBox, .main {
        font-size:18px;
        font-weight: normal;
    }

    .main {
         width:100%;
         padding:15px;  
    }
}

@media (min-width: 992px) {
    .nav, .message, .editBox, .main {
        font-size:20px;
        font-weight: normal;
    }

    .main {
         width:350px;
         padding:50px;
    }
}



@media (min-width: 992px) {
    .slide.ng-enter,
    .slide.ng-leave { 
        position:absolute; 
        left:15px; 
        right:15px;
        transition:0.6s all ease;
        -moz-transition:0.6s all ease;
        -webkit-transition:0.6s all ease;         
    }
      
    .slide.ng-enter {  
        -webkit-animation:slideDown 0.6s both ease;
        -moz-animation:slideDown 0.6s both ease;
        animation:slideDown 0.6s both ease; 

    }
    .slide.ng-enter .nav {
        -webkit-animation:slide 0.4s both ease;
        -moz-animation:slide 0.4s both ease;
        animation:slide 0.4s both ease;    

        -webkit-animation-delay:.2s;
        -moz-animation-delay:.2s;
        animation-delay: .2s;
    }

   .slide.ng-leave {
        opacity: 0;       

    }
} 

@keyframes slide {
    from      {   transform: translateX(25%); }
    to          { transform: translateX(0%); }
}
@-moz-keyframes slide {
    from      { -moz-transform: translateX(25%); }
    to          { -moz-transform: translateX(0%); }
}
@-webkit-keyframes slide {
    from      { -webkit-transform: translateX(25%); }
    to          { -webkit-transform: translateX(0%); }
}

@keyframes slideDown {
    from    { transform:translateY(-200%); }
    to      { transform: translateY(0%); }
}
@-moz-keyframes slideDown {
    from    { -moz-transform:translateY(-200%); }
    to      { -moz-transform: translateY(0%); }
}
@-webkit-keyframes slideDown {
    from    { -webkit-transform:translateY(-200%); }
    to      { -webkit-transform: translateY(0%); }
}   