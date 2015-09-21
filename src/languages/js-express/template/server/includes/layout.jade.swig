doctype html
html
    head
        meta(name="viewport" content="width=device-width, initial-scale=1")
        link(rel='stylesheet', href='//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css')
        link(rel='stylesheet', href='//netdna.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css')
        link(rel='stylesheet', href='css/toastr.css')
        link(rel='stylesheet', href='css/style.css')

    body(ng-app="app")
        block main-content

    include scripts