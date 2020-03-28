
$(document).ready(function() {
    if (typeof indev !== 'undefined') {
        SyncInventory('[{"quantity":1,"isequipped":false,"type":"consumable","name":"beer","modelid":662}]');
    }
});

function UseItem(name) {
    CallEvent('UseItem', name);
}

function EquipItem(name) {
    CallEvent('EquipItem', name);
}

function UnequipItem(name) {
    CallEvent('UnequipItem', name)
}

function DropItem(name) {
    CallEvent('DropItem', name);
}

function SyncInventory(data) {
    console.log(data);
    items = JSON.parse(data);

    // clear inventory slots
    $('.slot').empty();

    // populate slot contents
    $.each(items, function (i, item) {
        i = i + 1;
        let html = `<img src="http://game/objects/${item['modelid']}"></img>`;
        if (item['quantity'] > 1) {
            html += `<span class="quantity">${item['quantity']}</span>`;
        }
        html += `<div class="options">`;
        if (item['usable']) {
            html += `<a onClick="UseItem('${item['name']}')" href="#">Use</a>`;
        }
        if (item['equipable']) {
            html += `<a onClick="EquipItem('${item['name']}')" href="#">Equip</a>`;
        }
        if (item['isequipped']) {
            html += `<a onClick="UnequipItem('${item['name']}')" href="#">Unequip</a>`;
        }
        html += `<a onClick="DropItem('${item['name']}')" href="#">Drop</a></div>`;
        $('#slot-'+i).html(html);
    });
}