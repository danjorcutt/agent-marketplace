package agentmarketplace

import "time"

// Rate kinds for an agent's listed price.
const (
	RateHourly = "hourly"
	RateFlat   = "flat"
)

// Task statuses. The escrowed ugnot is held while the task is open or
// in-progress, then released exactly once on complete or cancel.
const (
	StatusOpen       = "open"
	StatusInProgress = "in-progress"
	StatusCompleted  = "completed"
	StatusCancelled  = "cancelled"
)

// Agent is a registered worker. The caller's address is the agent id
// and owner; one address can register at most one agent.
type Agent struct {
	Owner        address
	Name         string
	Tags         string // canonical, comma-space separated specialties
	RateKind     string
	RateUgnot    int64
	RegisteredAt time.Time
	Completed    int
	EarnedUgnot  int64
}

// Task is a job posted with an ugnot budget held in escrow by the realm.
type Task struct {
	ID          int
	Poster      address
	Title       string
	Description string
	Specialty   string // required specialty tag
	BudgetUgnot int64
	Status      string
	PostedAt    time.Time

	WinningBidID int
	Winner       address
	AcceptedAt   time.Time
	CompletedAt  time.Time
	Settled      bool // true after payout or refund; prevents double settlement
}

// Bid is one agent's offer on an open task.
type Bid struct {
	ID       int
	TaskID   int
	Agent    address
	Amount   int64 // ugnot, must be > 0 and <= the task budget
	Note     string
	PlacedAt time.Time
}
