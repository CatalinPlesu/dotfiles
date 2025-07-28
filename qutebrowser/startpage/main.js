data = {
	"💡 SaaS":[ // Emoji directly in category key
		["📈 Indie Hackers","https://www.indiehackers.com/"],
		["🚀 SaaStr", "https://www.saastr.com/"],
		["🤝 MicroConf", "https://microconf.com/"],
		["🧠 Paul Graham Essays", "http://www.paulgraham.com/articles.html"],
	],

	"🟣 Elixir Stack":[ // Emoji directly in category key
		["✨ Elixir Lang", "https://elixir-lang.org/docs.html"],
		["🔥 Phoenix Framework", "https://hexdocs.pm/phoenix/overview.html"],
		["🌳 Ash Framework", "https://ash-hq.org/"],
		["📚 HexDocs", "https://hexdocs.pm/"],
	],

	"🛠️ Dev Tools":[ // Emoji directly in category key
		["⏰ Wakatime", "https://wakatime.com/dashboard"],
		["🐙 GitHub", "https://github.com/"],
		["🦊 GitLab", "https://gitlab.com/"],
		["💻 Your SaaS Repo", "https://github.com/catalinplesu/your-saas-project"],
	],

	"⚙️ DevOps":[ // Emoji directly in category key
		["☁️ Fly.io Dash", "https://fly.io/dashboard"],
		["🐘 PostgreSQL Docs", "https://www.postgresql.org/docs/"],
		["🚨 Sentry", "https://sentry.io/"],
		["💳 Stripe Dash", "https://dashboard.stripe.com/"],
	],

	"🌐 UI/UX":[ // Emoji directly in category key
		["🎨 Tailwind UI", "https://tailwindui.com/"],
		["🖼️ Heroicons", "https://heroicons.com/"],
		["📐 Figma", "https://www.figma.com/"],
		["✏️ Open Doodles", "https://www.opendoodles.com/"],
	],

	"🗣️ Community":[ // Emoji directly in category key
		["💬 Elixir Forum", "https://elixirforum.com/"],
		["🗣️ Phoenix Discord", "https://discord.gg/your-phoenix-discord"],
		["🐦 X (SaaS/Tech)", "https://x.com/CatalinPlesu"],
		["📧 Main Mail", "https://mail.google.com/mail/u/1/#inbox"],
	],
}

window.addEventListener('load', function () {
    var target = document.getElementById("target");
    // Clear existing content if any
    target.innerHTML = '';

    let container = document.createElement("div");
    container.id = "links-container"; // Add an ID for styling
    target.appendChild(container);

    for (let head in data) {
        let categoryDiv = document.createElement("div");
        categoryDiv.classList.add("category-column"); // Class for styling
        
        let header = document.createElement("h2");
        header.innerText = head.replace(/_/g, ' '); // Replace underscores with spaces for display
        categoryDiv.appendChild(header);

        let linkList = document.createElement("div");
        linkList.classList.add("link-list"); // Class for styling individual links within a column

        data[head].forEach(linkInfo => {
            let linkWrapper = document.createElement("div"); // Wrapper for each link to allow individual styling/wrapping
            let a = document.createElement("a");
            a.innerText = linkInfo[0];
            a.href = linkInfo[1];
            linkWrapper.appendChild(a);
            linkList.appendChild(linkWrapper);
        });
        categoryDiv.appendChild(linkList);
        container.appendChild(categoryDiv);
    }
});
