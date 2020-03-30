
$(document).ready(function() {
    if (typeof indev !== 'undefined') {
        SyncInventory('[{"quantity":1,"isequipped":false,"type":"consumable","name":"beer","modelid":662}]');
    }
});

function UseObject(name) {
    CallEvent('UseObject', name);
}

function EquipObject(name) {
    CallEvent('EquipObject', name);
}

function UnequipObject(name) {
    CallEvent('UnequipObject', name)
}

function DropObject(name) {
    CallEvent('DropObject', name);
}

function SyncInventory(data) {
    console.log(data);
    objects = JSON.parse(data);
 
    // clear inventory slots
    $('.slot').empty();

    // populate slot contents
    $.each(objects, function (i, object) {
        i = i + 1;
        let html = `<img src="http://game/objects/${object['modelid']}"></img>`;
        if (object['quantity'] > 1) {
            html += `<span class="quantity">${object['quantity']}</span>`;
        }
        html += `<div class="options">`;
        if (object['usable']) {
            let use_label = 'Use';

            if (object['use_label']) {
                use_label = object['use_label'];
            }

            html += `<a onClick="UseObject('${object['name']}')" href="#">${use_label}</a>`;
        }
        if (object['equipable'] && !object['isequipped']) {
            html += `<a onClick="EquipObject('${object['name']}')" href="#">Equip</a>`;
        }
        if (object['isequipped']) {
            html += `<a onClick="UnequipObject('${object['name']}')" href="#">Unequip</a>`;
        }
        html += `<a onClick="DropObject('${object['name']}')" href="#">Drop</a></div>`;
        $('#slot-'+i).html(html);
    });
}