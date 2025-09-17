# EKO

EKO is a memory-based game built in Godot 4, inspired by Simon Says. Players must memorize and repeat a sequence of button presses that grows longer each round. Navigate a character to interact with buttons, collect replay orbs, and test your memory to reach Round 11!

## How to Play

### Objective
- Memorize and repeat the sequence of buttons shown by the game.
- Survive 10 rounds to win. You have 3 lives and up to 3 replays to help you succeed.

### Controls
- **WASD**: Move the player character.
- **P**: Pause the game to access the Pause Menu.
- **Replay Button**: Click the "Replay Pattern" button in the top-left HUD to replay the current sequence (requires a Replay Orb, max 3 uses).
- **Interact with Buttons**: Move the player into a button to press it during your turn.

### Gameplay
1. **Start**: The game begins with a countdown ("3", "2", "1", "Go!") on the center screen.
2. **Pattern Playback**:
   - The game flashes a sequence of buttons.
   - The HUD displays "Wait" during the sequence.
3. **Player's Turn**:
   - The HUD shows "EKO" when it’s your turn to repeat the sequence.
   - Move the player into the buttons in the correct order.
   - If correct, the HUD shows "Correct!", and the next round starts with a new button added to the sequence.
   - If incorrect, the HUD shows "NO", you lose a life, and the pattern replays (unless no lives remain).
4. **Replay Orb**:
   - A Replay Orb may spawn randomly (30% chance per round).
   - Collect it by moving the player into it to enable the "Replay Pattern" button.
   - Use replays (up to 3) to re-watch the current sequence.
5. **HUD**:
   - **Top-Left**: Shows Score, Round, Lives, and Replays.
   - **Center**: Shows countdown, "Wait", "EKO", "Correct!", or "NO".
6. **Win/Lose**:
   - **Win**: Complete Round 10 (sequence of 10 buttons) to return to the Main Menu.
   - **Lose**: Lose all 3 lives to return to the Main Menu.

### Scoring
- Earn 10 points per round (multiplied by round number, e.g., 10 points in Round 1, 20 in Round 2).

## Setup Instructions
1. **Install Godot 4**:
   - Download and install Godot Engine 4.x from [godotengine.org](https://godotengine.org/).
2. **Clone the Repository**:
3. **Open the Project**:
   - Launch Godot 4, click "Import", and select the `project.godot` file in the repository.
4. **Run the Game**:
   - Set `res://scenes/MainMenu.tscn` as the main scene in Godot (Project > Project Settings > Application > Run > Main Scene).
   - Press F5 to run, or click "Start Game" in the Main Menu.
5. **Assets**:
   - Ensure all assets (sprites, sounds) are in the `res://` directory, as referenced in `Game.tscn` and `Button.tscn`.
   - Required nodes: `ButtonRed`, `ButtonBlue`, `ButtonGreen`, `ButtonYellow` (with `color` properties set), `Player`, `ReplayOrb`, `SimonNPC`, `bg_music`, `sfx_player`, `HUD` (with `Score`, `Round`, `Lives`, `Replays`, `ReplayButton`, `Countdown`).
