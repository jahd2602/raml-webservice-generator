<ul class="nav nav-pills">
    <li ng-class="{'active':true}"><a href='#/main'>Main</a></li>
    <li ng-class="{'active':false}"><a href='#/edit'>Edit</a></li>
    <li><a href='/api'>JSON API</a></li>
</ul>
<br/>
<div class='main'>
    MongoDb online - {% raw %}{{items.length}}{% endraw %} records<br/>
    {% raw %}{{myVar}}{% endraw %}<br/>
    So is <i class="fa fa-spinner fa-spin"></i> font-awesome.
</div>