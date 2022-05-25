(function() {
    var grades = {};
    grades["total"] = { "sum": 0, "count": 0 };
    var rows = document.querySelectorAll("table > tbody > tr");

    for (i = 0; i < rows.length; i++) {
        var semester = rows[i].querySelectorAll("td")[0].innerText;
        if (!grades[semester]) {
            grades[semester] = { "sum": 0, "count": 0 };
        }
        var value = parseFloat(rows[i].querySelectorAll("td")[3].innerText.replace(",", "."));
        if (value) {
            grades[semester]["sum"] += value;
            grades[semester]["count"] += 1;
            grades["total"]["sum"] += value;
            grades["total"]["count"] += 1;
        }
    }

    var response = ""

    for (key in grades) {
        response += `media in semestrul ${key}: ${grades[key]["sum"]/grades[key]["count"]}\n`;
    }

    console.log(response);
    alert(response);
})();
