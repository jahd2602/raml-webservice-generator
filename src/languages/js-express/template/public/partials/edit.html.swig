<ul class="nav nav-pills">
    <li ng-class="{'active':false}"><a href='#/main'>Main</a></li>
    <li ng-class="{'active':true}"><a href='#/edit'>Edit</a></li>
    <li><a href='/api'>JSON API</a></li>
</ul>

<hr>
<form ng-submit='save()'>
    <input type='text' ng-model='test' Required/>
    <button class='btn btn-success' type="submit"><i class='fa fa-plus'> Add</i></button>
</form>

<p>
<div class='output'>
    <table class="table table-striped">
        <tr ng-repeat='item in items'>
            <td editable='item' index='{% raw %}{{$index}}{% endraw %}'></td>
        </tr>
    </table>
</div>

