window.addEventListener('message', (event) => {
    if (event.data.type == 1){
        LoadCharacters(event.data.list);
    } else if(event.data.type == 2) {
        window.location.reload();
    } else if(event.data.type == "hide") {
        $(".container").fadeOut(500);
        $(".container").html('');
    } else if(event.data.type == "translation") {
        LOCALE = event.data.locale
    }
});

var Identity = {};
var LimitCharacters = 3

function LoadCharacters(list) {

    $(".loading").html('');
    
    $(".container").html(`    
        <div class="header-text">${LOCALE.CHARACTERS}</div>			

        <div class="description-text">${LOCALE.DESCRIPTION}</div>		

        <div class="main">

        </div>
        <div class="bottom-line"></div>

        <div class="buttons">

            <div class="enter-world" onclick="enterWorld()">
            ${LOCALE.ENTER_WORLD}
            </div>

        </div>
    `);


    let listLength = 0;

    if (list) {
        listLength = list.length;
    }

    for (let i = 0; i < listLength; i++){
        let char = list[i];

        $(".main").append(`
            <div class="char ${i}" onclick="charSelected(${char.id}, ${i})">
                <div class="char_name">${char.firstName} ${char.lastName}</div>
            </div>
        `);     
    }

    let empty_slot = LimitCharacters - listLength;   

    if (empty_slot > 0) {
        for (let i = 0; i < empty_slot; i++){
            $(".main").append(`
            <div class="empty" onclick="createNewCharacter()">
                <span>${LOCALE.CREATE_CHAR}</span>
            </div>        
        `);     
        }
    }    
}

$(document).on('click', '.char', function(e){
    $(".selected").removeClass("selected");
    e.currentTarget.className += " selected";
});

function charSelected(charId, index) {			
    Identity.CharSelected = charId;
    $(".enter-world").css("opacity", "1")
    $.post('https://frp_spawn_selector/selectCharacter', JSON.stringify(charId));
}

function enterWorld() {			
    if(Identity.CharSelected != null){

        $.post('https://frp_spawn_selector/spawnCharacterSelected', JSON.stringify(Identity.CharSelected));

        $(".container").fadeOut(500);        
        setTimeout(function(){ $(".container").html(''); }, 2000);
        
    }
}

function createNewCharacter() {

    // $(".container").fadeOut(500);
    // $(".container").html('');

    $.post('https://frp_spawn_selector/createCharacter', JSON.stringify({}));
}


function deleteChar() {
    if(Identity.CharSelected != null){
        $.post('https://frp_spawn_selector/deleteCharacter', JSON.stringify(Identity.CharSelected));
    }
}

