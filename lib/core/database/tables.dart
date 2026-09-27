/// SQL schema for the local database (spec §2.4). Source of truth for tables.
const List<String> kCreateTableStatements = [
  '''
CREATE TABLE user_profile (
  id INTEGER PRIMARY KEY DEFAULT 1,
  level INTEGER DEFAULT 1,
  total_xp INTEGER DEFAULT 0,
  current_streak INTEGER DEFAULT 0,
  longest_streak INTEGER DEFAULT 0,
  streak_start_date TEXT,
  brain_stage TEXT DEFAULT 'dormant',
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
)''',
  '''
CREATE TABLE daily_checkins (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  date TEXT UNIQUE NOT NULL,
  status TEXT NOT NULL CHECK(status IN ('clean', 'relapse')),
  mood INTEGER CHECK(mood BETWEEN 1 AND 5),
  notes TEXT,
  xp_earned INTEGER DEFAULT 0,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
)''',
  '''
CREATE TABLE triggers (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  date TEXT NOT NULL,
  description TEXT NOT NULL,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
)''',
  '''
CREATE TABLE meditation_sessions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  date TEXT NOT NULL,
  duration_seconds INTEGER NOT NULL,
  audio_type TEXT,
  breathing_type TEXT,
  xp_earned INTEGER DEFAULT 0,
  completed INTEGER DEFAULT 1,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
)''',
  '''
CREATE TABLE workout_sessions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  date TEXT NOT NULL,
  routine_id TEXT NOT NULL,
  routine_name TEXT NOT NULL,
  duration_seconds INTEGER NOT NULL,
  exercises_completed INTEGER NOT NULL,
  exercises_total INTEGER NOT NULL,
  xp_earned INTEGER DEFAULT 0,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
)''',
  '''
CREATE TABLE quests (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  quest_id TEXT NOT NULL,
  type TEXT NOT NULL CHECK(type IN ('daily', 'weekly')),
  title TEXT NOT NULL,
  description TEXT,
  xp_reward INTEGER NOT NULL,
  target_value INTEGER DEFAULT 1,
  current_value INTEGER DEFAULT 0,
  completed INTEGER DEFAULT 0,
  date_assigned TEXT NOT NULL,
  date_completed TEXT,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
)''',
  '''
CREATE TABLE achievements (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  badge_id TEXT UNIQUE NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  icon TEXT,
  unlocked INTEGER DEFAULT 0,
  date_unlocked TEXT,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
)''',
  '''
CREATE TABLE streaks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  start_date TEXT NOT NULL,
  end_date TEXT,
  length INTEGER NOT NULL,
  ended_by TEXT CHECK(ended_by IN ('relapse', 'active')),
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
)''',
];
