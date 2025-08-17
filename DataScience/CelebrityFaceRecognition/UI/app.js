Dropzone.autoDiscover = false;

function init() {
    let dz = new Dropzone("#dropzone", {
        url: "/",
        maxFiles: 1,
        addRemoveLinks: true,
        dictDefaultMessage: "Some Message",
        autoProcessQueue: false
    });
    
    dz.on("addedfile", function() {
        if (dz.files[1]!=null) {
            dz.removeFile(dz.files[0]);        
        }
    });
    dz.on("complete", function (file) {
    let imageData = file.dataURL;

    var url = "http://127.0.0.1:5000/classify_image";
    //var url = "/api/classify_image"
    $.post(url, {
        image_data: imageData
    }, function (data, status) {
        console.log(data);

        // Clear previous results
        $("#resultHolder").html("");

        if (!data || data.length === 0) {
            $("#resultHolder").hide();
            $("#divClassTable").hide();
            $("#error").show();
            return;
        }

        $("#error").hide();
        $("#resultHolder").show();
        $("#divClassTable").show();

        // Loop through all detected people
        data.forEach(function (person) {
            // Append corresponding card to the resultHolder
            let cardHtml = $(`[data-player="${person.class}"]`).html();
            $("#resultHolder").append(`
                <div class="card border-0 mb-3">
                    ${cardHtml}
                </div>
            `);

            // Update class probabilities in the table
            let classDictionary = person.class_dictionary;
            for (let personName in classDictionary) {
                let index = classDictionary[personName];
                let score = person.class_probability[index];
                $(`#score_${personName}`).html(score.toFixed(2)); // format to 2 decimals
            }
        });
    });
});



    $("#submitBtn").on('click', function (e) {
        dz.processQueue();		
    });
}

$(document).ready(function() {
    console.log( "ready!" );
    $("#error").hide();
    $("#resultHolder").hide();
    $("#divClassTable").hide();

    init();
});