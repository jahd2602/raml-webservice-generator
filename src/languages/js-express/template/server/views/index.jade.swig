extends ../includes/layout
block main-content
    section
        div(class='col-md-8 col-md-offset-2' )
            h2
                div(ng-view class='slide')
