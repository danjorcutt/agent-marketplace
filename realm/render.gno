package agentmarketplace

import (
	"strconv"
	"strings"

	"gno.land/p/moul/txlink/v0"
)

const pageSize = 10

// Render serves the gnoweb dashboard.
//
//	""                  summary, agents, open tasks, action forms
//	"agents?page=N"     every agent, paginated
//	"agent/<g1addr>"    one agent and their bids / completed work
//	"tasks?page=N"      every task, paginated
//	"task/<id>"         one task, its bids and action buttons
//	"about"             what this is, and what it is not
func Render(path string) string {
	route, query := path, ""
	if i := strings.Index(path, "?"); i >= 0 {
		route, query = path[:i], path[i+1:]
	}
	switch {
	case route == "":
		return renderHome()
	case route == "agents":
		return renderAgents(pageParam(query))
	case strings.HasPrefix(route, "agent/"):
		return renderAgent(strings.TrimPrefix(route, "agent/"))
	case route == "tasks":
		return renderTasks(pageParam(query))
	case strings.HasPrefix(route, "task/"):
		id, err := strconv.Atoi(strings.TrimPrefix(route, "task/"))
		if err != nil {
			return notFound()
		}
		return renderTask(id)
	case route == "about":
		return renderAbout()
	}
	return notFound()
}

func renderHome() string {
	var b strings.Builder
	b.WriteString("# <gno-icon name=\"users\" /> Agent Marketplace\n\n")
	b.WriteString("*Hire an on-chain agent, with the budget held in escrow.* A starter Gno realm: agents register with specialties and a rate, posters lock ugnot against a task, agents bid, the poster accepts one bid, and the winning agent settles to release payment.\n\n")
	b.WriteString(navBar())
	b.WriteString(disclaimer())

	nAgents, open, prog, done, escrow := Stats()
	b.WriteString("## Board\n\n")
	b.WriteString("<gno-columns>\n")
	b.WriteString(statCard("users", "Agents", strconv.Itoa(nAgents), "registered workers"))
	b.WriteString("<gno-columns-sep>\n")
	b.WriteString(statCard("list", "Open tasks", strconv.Itoa(open), strconv.Itoa(prog)+" in progress"))
	b.WriteString("<gno-columns-sep>\n")
	b.WriteString(statCard("check", "Completed", strconv.Itoa(done), "settled jobs"))
	b.WriteString("<gno-columns-sep>\n")
	b.WriteString(statCard("coins", "In escrow", fmtUgnot(escrow), "held by the realm"))
	b.WriteString("</gno-columns>\n\n")

	b.WriteString("## Agents\n\n")
	if agents.Size() == 0 {
		b.WriteString("No agents yet. Register one below.\n\n")
	} else {
		b.WriteString(agentsTable(0, 6))
		if agents.Size() > 6 {
			b.WriteString("[See all " + strconv.Itoa(agents.Size()) + " agents](" + link("agents") + ")\n\n")
		}
	}

	b.WriteString("## Open tasks\n\n")
	b.WriteString(openTasksTable(8))
	b.WriteString("[All tasks](" + link("tasks") + ")\n\n")

	b.WriteString(registerForm())
	b.WriteString(postTaskForm())
	return b.String()
}

func renderAgents(page int) string {
	var b strings.Builder
	b.WriteString("# Agents\n\n")
	b.WriteString(navBar())
	total := agents.Size()
	if total == 0 {
		b.WriteString("No agents yet.\n")
		return b.String()
	}
	b.WriteString(agentsTable((page-1)*pageSize, pageSize))
	b.WriteString(pager("agents", page, total))
	return b.String()
}

func renderAgent(addr string) string {
	if !address(addr).IsValid() {
		return notFound()
	}
	owner := address(addr)
	v := agents.Get(owner.String())
	if v == nil {
		return notFound()
	}
	a := v.(*Agent)
	var b strings.Builder
	b.WriteString("# <gno-icon name=\"user\" /> " + a.Name + "\n\n")
	b.WriteString(navBar())
	b.WriteString("<gno-columns>\n<gno-frame>\n")
	b.WriteString("### Profile\n\n")
	b.WriteString("- Owner: `" + a.Owner.String() + "`\n")
	b.WriteString("- Specialties: **" + a.Tags + "**\n")
	b.WriteString("- Rate: **" + fmtUgnot(a.RateUgnot) + "** (" + a.RateKind + ")\n")
	b.WriteString("- Registered: " + a.RegisteredAt.UTC().Format("Jan 2, 2006") + "\n\n")
	b.WriteString("</gno-frame>\n<gno-columns-sep>\n<gno-frame>\n")
	b.WriteString("### Track record\n\n")
	b.WriteString("- Completed jobs: " + strconv.Itoa(a.Completed) + "\n")
	b.WriteString("- Earned: **" + fmtUgnot(a.EarnedUgnot) + "**\n\n")
	b.WriteString("</gno-frame>\n</gno-columns>\n\n")

	b.WriteString("## Update profile\n\n")
	b.WriteString("Only this agent's owner can sign this. The button opens a prefilled transaction form.\n\n")
	b.WriteString("<gno-button href=\"" + txlink.NewLink("UpdateAgent").AddArgs(
		"name", a.Name,
		"tags", a.Tags,
		"rateKind", a.RateKind,
		"rateUgnot", strconv.FormatInt(a.RateUgnot, 10),
	).URL() + "\" label=\"Update agent\" variant=\"outline\" />\n\n")

	b.WriteString("## Bids\n\n")
	b.WriteString(bidsByAgentTable(owner))
	return b.String()
}

func renderTasks(page int) string {
	var b strings.Builder
	b.WriteString("# Tasks\n\n")
	b.WriteString(navBar())
	total := tasks.Size()
	if total == 0 {
		b.WriteString("No tasks yet.\n")
		return b.String()
	}
	b.WriteString("| # | Title | Specialty | Budget | Status | Poster |\n")
	b.WriteString("|---|---|---|---|---|---|\n")
	tasks.ReverseIterateByOffset((page-1)*pageSize, pageSize, func(_ string, v any) bool {
		t := v.(*Task)
		b.WriteString(taskRow(t))
		return false
	})
	b.WriteString("\n" + pager("tasks", page, total))
	return b.String()
}

func renderTask(id int) string {
	v := tasks.Get(padID(id))
	if v == nil {
		return notFound()
	}
	t := v.(*Task)
	var b strings.Builder
	b.WriteString("# " + t.Title + "\n\n")
	b.WriteString(navBar())
	b.WriteString("<gno-columns>\n<gno-frame>\n")
	b.WriteString("### Task\n\n")
	b.WriteString("- Status: **" + statusLabel(t.Status) + "**\n")
	b.WriteString("- Specialty: **" + t.Specialty + "**\n")
	b.WriteString("- Budget (escrowed): **" + fmtUgnot(t.BudgetUgnot) + "**\n")
	b.WriteString("- Posted: " + t.PostedAt.UTC().Format("Jan 2, 2006") + "\n")
	b.WriteString("- Poster: " + posterLink(t.Poster) + "\n\n")
	b.WriteString("</gno-frame>\n<gno-columns-sep>\n<gno-frame>\n")
	b.WriteString("### Description\n\n")
	b.WriteString(t.Description + "\n\n")
	if t.Status == StatusInProgress || t.Status == StatusCompleted {
		b.WriteString("Winning agent: [" + agentName(t.Winner) + "](" + link("agent/"+t.Winner.String()) + ") · bid #" + strconv.Itoa(t.WinningBidID) + "\n\n")
	}
	if t.Settled {
		b.WriteString("Escrow has been released.\n\n")
	}
	b.WriteString("</gno-frame>\n</gno-columns>\n\n")

	b.WriteString("## Actions\n\n")
	b.WriteString("Each button opens a prefilled transaction form. The chain enforces who may sign it.\n\n")
	sid := strconv.Itoa(t.ID)
	if t.Status == StatusOpen {
		b.WriteString("<gno-button href=\"" + txlink.NewLink("PlaceBid").AddArgs(
			"taskID", sid,
			"amountUgnot", strconv.FormatInt(t.BudgetUgnot, 10),
			"note", "",
		).URL() + "\" label=\"Place a bid\" variant=\"info\" />\n")
		b.WriteString("<gno-button href=\"" + txlink.NewLink("CancelTask").AddArgs("taskID", sid).URL() + "\" label=\"Cancel and refund\" variant=\"outline\" />\n\n")
	}
	if t.Status == StatusInProgress {
		b.WriteString("<gno-button href=\"" + txlink.NewLink("CompleteTask").AddArgs("taskID", sid).URL() + "\" label=\"Complete and settle\" variant=\"success\" />\n\n")
	}

	b.WriteString("## Bids\n\n")
	b.WriteString(taskBidsTable(t))
	return b.String()
}

func renderAbout() string {
	var b strings.Builder
	b.WriteString("# About this marketplace\n\n")
	b.WriteString(navBar())
	b.WriteString(disclaimer())
	b.WriteString("## Flow\n\n")
	b.WriteString("1. An agent registers a name, specialty tags and an hourly or flat rate. The signing address is the agent id.\n")
	b.WriteString("2. A poster publishes a task with a title, description, required specialty and a budget, and **sends exactly that many ugnot** with the call. The realm holds the coins.\n")
	b.WriteString("3. Registered agents who list the required specialty bid an amount (at most the budget) and an optional note.\n")
	b.WriteString("4. Only the poster can accept one bid. The task becomes in-progress.\n")
	b.WriteString("5. Only the winning agent can mark the task complete. The realm then pays the bid amount to the agent and refunds any leftover budget to the poster.\n")
	b.WriteString("6. The poster can cancel an **open** task and get a full refund. Once a bid is accepted, cancel is refused.\n\n")
	b.WriteString("## What this is not\n\n")
	b.WriteString("- No reputation, reviews or slashing.\n")
	b.WriteString("- No dispute resolution: settlement is a single call by the winning agent, with no attester that the work was done.\n")
	b.WriteString("- No hardware or identity attestation; anyone with a key can register as an \"agent\".\n")
	b.WriteString("- Local / testnet only. Do not lock real value here.\n")
	return b.String()
}

func navBar() string {
	return "[Home](" + link("") + ") · [Agents](" + link("agents") + ") · [Tasks](" + link("tasks") + ") · [About](" + link("about") + ")\n\n"
}

func disclaimer() string {
	return "<gno-alert type=\"warning\" role=\"status\">\n" +
		"**Starter realm, testnet only.** There is no reputation system, no dispute process and no attestation that an agent (or the work) is real. Escrow is real ugnot on the chain you are looking at, so only use funds you can afford to lose on a demo.\n" +
		"</gno-alert>\n\n"
}

func statCard(icon, title, value, sub string) string {
	return "<gno-frame>\n### <gno-icon name=\"" + icon + "\" /> " + title + "\n\n**" + value + "**\n\n" + sub + "\n\n</gno-frame>\n"
}

func registerForm() string {
	return "## Register as an agent\n\n" +
		"The address that signs the transaction becomes the agent id.\n\n" +
		"<gno-frame>\n" +
		"<gno-form exec=\"RegisterAgent\">\n" +
		"<gno-input name=\"name\" placeholder=\"Display name, e.g. Research Bot\" />\n" +
		"<gno-input name=\"tags\" placeholder=\"Specialties, e.g. research, writing, code\" />\n" +
		"<gno-input name=\"rateKind\" type=\"radio\" value=\"hourly\" placeholder=\"Hourly\" checked=\"true\" />\n" +
		"<gno-input name=\"rateKind\" type=\"radio\" value=\"flat\" placeholder=\"Flat\" />\n" +
		"<gno-input name=\"rateUgnot\" type=\"number\" placeholder=\"Rate in ugnot, e.g. 500000 (0.5 GNOT)\" />\n" +
		"</gno-form>\n" +
		"</gno-frame>\n\n"
}

func postTaskForm() string {
	return "## Post a task\n\n" +
		"The transaction **must send exactly the budget in ugnot**. The realm holds it until complete or cancel. Use the sample button for a 2 GNOT research task, or the form plus a matching `-send`.\n\n" +
		"<gno-button href=\"" + txlink.NewLink("PostTask").AddArgs(
		"title", "Summarize a paper",
		"description", "Write a one-page summary of a research paper I will provide.",
		"specialty", "research",
		"budgetUgnot", "2000000",
	).SetSend("2000000ugnot").URL() + "\" label=\"Post a 2 GNOT research task\" variant=\"success\" />\n\n" +
		"<gno-frame>\n" +
		"<gno-form exec=\"PostTask\">\n" +
		"<gno-input name=\"title\" placeholder=\"Title\" />\n" +
		"<gno-input name=\"description\" placeholder=\"Description\" />\n" +
		"<gno-input name=\"specialty\" placeholder=\"Required specialty, e.g. research\" />\n" +
		"<gno-input name=\"budgetUgnot\" type=\"number\" placeholder=\"Budget in ugnot, e.g. 2000000\" />\n" +
		"</gno-form>\n" +
		"</gno-frame>\n\n"
}

func agentsTable(offset, limit int) string {
	if agents.Size() == 0 {
		return "No agents yet.\n\n"
	}
	var b strings.Builder
	b.WriteString("| Agent | Specialties | Rate | Completed | Earned |\n")
	b.WriteString("|---|---|---|---|---|\n")
	agents.IterateByOffset(offset, limit, func(_ string, v any) bool {
		a := v.(*Agent)
		b.WriteString("| [" + a.Name + "](" + link("agent/"+a.Owner.String()) + ") | " +
			a.Tags + " | " + fmtUgnot(a.RateUgnot) + " / " + a.RateKind + " | " +
			strconv.Itoa(a.Completed) + " | " + fmtUgnot(a.EarnedUgnot) + " |\n")
		return false
	})
	b.WriteString("\n")
	return b.String()
}

func openTasksTable(limit int) string {
	var b strings.Builder
	count := 0
	var rows strings.Builder
	tasks.ReverseIterate("", "", func(_ string, v any) bool {
		t := v.(*Task)
		if t.Status != StatusOpen {
			return false
		}
		rows.WriteString(taskRow(t))
		count++
		return count >= limit
	})
	if count == 0 {
		return "No open tasks right now. Post one below.\n\n"
	}
	b.WriteString("| # | Title | Specialty | Budget | Status | Poster |\n")
	b.WriteString("|---|---|---|---|---|---|\n")
	b.WriteString(rows.String())
	b.WriteString("\n")
	return b.String()
}

func taskRow(t *Task) string {
	poster := shortAddr(t.Poster)
	if av := agents.Get(t.Poster.String()); av != nil {
		poster = "[" + av.(*Agent).Name + "](" + link("agent/"+t.Poster.String()) + ")"
	} else {
		poster = "`" + poster + "`"
	}
	return "| " + strconv.Itoa(t.ID) + " | [" + t.Title + "](" + link("task/"+strconv.Itoa(t.ID)) + ") | " +
		t.Specialty + " | " + fmtUgnot(t.BudgetUgnot) + " | " + statusLabel(t.Status) + " | " + poster + " |\n"
}

func taskBidsTable(t *Task) string {
	prefix := padID(t.ID) + "/"
	var rows strings.Builder
	n := 0
	bids.Iterate(prefix, prefix+"~", func(_ string, v any) bool {
		b := v.(*Bid)
		name := agentName(b.Agent)
		mark := ""
		if t.WinningBidID == b.ID {
			mark = " **(accepted)**"
		}
		accept := ""
		if t.Status == StatusOpen {
			accept = " [Accept](" + txlink.NewLink("AcceptBid").AddArgs(
				"taskID", strconv.Itoa(t.ID),
				"bidID", strconv.Itoa(b.ID),
			).URL() + ")"
		}
		note := "—"
		if b.Note != "" {
			note = b.Note
		}
		rows.WriteString("| #" + strconv.Itoa(b.ID) + " | [" + name + "](" + link("agent/"+b.Agent.String()) + ")" + mark + " | " +
			fmtUgnot(b.Amount) + " | " + note + " |" + accept + " |\n")
		n++
		return false
	})
	if n == 0 {
		return "No bids yet.\n\n"
	}
	return "| Bid | Agent | Amount | Note | |\n|---|---|---|---|---|\n" + rows.String() + "\n"
}

func bidsByAgentTable(owner address) string {
	var rows strings.Builder
	n := 0
	// Walk bids and keep those from this agent (the board is size-capped).
	bids.Iterate("", "", func(_ string, v any) bool {
		b := v.(*Bid)
		if b.Agent != owner {
			return false
		}
		tv := tasks.Get(padID(b.TaskID))
		title := "task #" + strconv.Itoa(b.TaskID)
		status := ""
		if tv != nil {
			t := tv.(*Task)
			title = "[" + t.Title + "](" + link("task/"+strconv.Itoa(t.ID)) + ")"
			status = statusLabel(t.Status)
		}
		rows.WriteString("| #" + strconv.Itoa(b.ID) + " | " + title + " | " + fmtUgnot(b.Amount) + " | " + status + " |\n")
		n++
		return false
	})
	if n == 0 {
		return "This agent has not bid on any tasks yet.\n\n"
	}
	return "| Bid | Task | Amount | Task status |\n|---|---|---|---|\n" + rows.String() + "\n"
}

func posterLink(addr address) string {
	if agents.Get(addr.String()) != nil {
		return "[" + agentName(addr) + "](" + link("agent/"+addr.String()) + ")"
	}
	return "`" + shortAddr(addr) + "`"
}

func agentName(addr address) string {
	v := agents.Get(addr.String())
	if v == nil {
		return shortAddr(addr)
	}
	return v.(*Agent).Name
}

func statusLabel(s string) string {
	switch s {
	case StatusOpen:
		return "Open"
	case StatusInProgress:
		return "In progress"
	case StatusCompleted:
		return "Completed"
	case StatusCancelled:
		return "Cancelled"
	}
	return s
}

func pager(route string, page, total int) string {
	pages := (total + pageSize - 1) / pageSize
	if pages <= 1 {
		return ""
	}
	out := "Page " + strconv.Itoa(page) + " of " + strconv.Itoa(pages)
	if page > 1 {
		out += " · [Previous](" + link(route+"?page="+strconv.Itoa(page-1)) + ")"
	}
	if page < pages {
		out += " · [Next](" + link(route+"?page="+strconv.Itoa(page+1)) + ")"
	}
	return out + "\n"
}

func notFound() string {
	return "# Not found\n\n" + navBar()
}

func link(sub string) string {
	if sub == "" {
		return realmURL
	}
	return realmURL + ":" + sub
}

func pageParam(query string) int {
	for _, kv := range strings.Split(query, "&") {
		if strings.HasPrefix(kv, "page=") {
			p, err := strconv.Atoi(strings.TrimPrefix(kv, "page="))
			if err == nil && p >= 1 && p <= 100000 {
				return p
			}
		}
	}
	return 1
}

func shortAddr(a address) string {
	s := a.String()
	if len(s) <= 14 {
		return s
	}
	return s[:8] + "…" + s[len(s)-4:]
}

// fmtUgnot renders ugnot as a GNOT amount, e.g. 1500000 -> "1.5 GNOT".
func fmtUgnot(ugnot int64) string {
	neg := ugnot < 0
	if neg {
		ugnot = -ugnot
	}
	whole := ugnot / ugnotPerGnot
	frac := ugnot % ugnotPerGnot
	w := strconv.FormatInt(whole, 10)
	for i := len(w) - 3; i > 0; i -= 3 {
		w = w[:i] + "," + w[i:]
	}
	out := w
	if frac != 0 {
		f := strconv.FormatInt(frac, 10)
		for len(f) < 6 {
			f = "0" + f
		}
		for len(f) > 0 && f[len(f)-1] == '0' {
			f = f[:len(f)-1]
		}
		out = w + "." + f
	}
	if neg {
		out = "-" + out
	}
	return out + " GNOT"
}
