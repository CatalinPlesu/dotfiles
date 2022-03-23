data = {
	"Soc":[
		["206","https://discord.com/channels/742508750258176152/747139629634945054"],
		["telegram","https://web.telegram.org/k/"],
		["discord", "https://discord.com/app/"],
		["twitter", "https://twitter.com/catalinplesu"],
	],

	"Lrn":[
		["type", "https://play.typeracer.com/"],
		["read", "https://readspeeder.com/lessons.html"],
		["monke", "https://monkeytype.com/"],
		["wars", "https://www.codewars.com/dashboard"],
	],

	"Ent":[
		["devian", "https://www.deviantart.com/"],
		["pix", "https://www.pixiv.net/en/"],
		["art", "https://www.artstation.com/?sort_by=community"],
		["pint", "https://www.pinterest.com/"],
	],

	"Res":[
		["wall", "https://wallhaven.cc/"],
		["png", "https://www.pngfind.com/"],
		["gifs", "http://1041uuu.tumblr.com/"],
		["pivs", "https://unsplash.com/t/wallpapers"],
	],

	"UTM":[
		["teams", "https://teams.microsoft.com/_?culture=en-us&country=WW&lm=deeplink&lmsrc=homePageWeb&cmpid=WebSignIn#/school/conversations/Comunitatea%20TI?threadId=19:90d27a023bb946789869210cebb6f86c@thread.tacv2&ctx=channel"],
		["simu", "https://simu.utm.md/students/"],
		["note", "file:///home/catalin/Documents/_notes/UTM/index.html"],
		["else", "https://else.fcim.utm.md/my/"],
		["outlook", "https://outlook.office.com/mail/inbox"],
		["self", "https://mail.google.com/mail/u/1/#inbox"],
		["fake", "https://mail.google.com/mail/u/0/#inbox"],
	],

	"Tech":[
		["arch", "https://archlinux.org/"],
		["gentoo", "https://wiki.gentoo.org/wiki/Main_Page"],
		["sync", "http://localhost:8384/"],
	],

	"Dev":[
		["cat", "https://github.com/catalinplesu"],
		["wakatime", "https://wakatime.com/dashboard"],
		["hub", "https://github.com/"],
		["lab", "https://gitlab.com/"],
	],
}
window.addEventListener('load', function () {
	var target = document.getElementById("target");
	let table = document.createElement("table");
	
	let tr = document.createElement("tr");
	let max = 0;
	for (head in data){
		if (data[head].length > max)
			max = data[head].length;
		let th = document.createElement("th");
		th.innerText = head;
		tr.appendChild(th);
	}
	table.appendChild(tr);
	for ( let i = 0 ; i <= max ; i++){
		let tr = document.createElement("tr");
			for (head in data){
				let td = document.createElement("td");
					if (data[head][i]){
						let a = document.createElement("a");
						a.innerText = data[head][i][0];
						a.href = data[head][i][1];
						td.appendChild(a);
					}
				tr.appendChild(td);
			}
		table.appendChild(tr);
	}
	target.appendChild(table);
})
