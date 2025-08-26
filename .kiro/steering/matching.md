# Track Matching & Version Filtering

## Overview
Syncra uses intelligent track matching when importing playlists from streaming services (Spotify, Deezer, Tidal) to find corresponding tracks in your Plex library. The matching system includes sophisticated version filtering to avoid unwanted matches.

## Version Filtering Logic

### Clean Source Tracks (No Version Info)
When the source track has no version information in parentheses or brackets, the system is now much more permissive:

**✅ Always Allowed (with preference ranking):**
- Remastered versions: `(Remastered)`, `(2021 Remaster)`, `(Remastered Edition)` - **Preferred** (+3 to +4 bonus)
- Audio formats: `(Stereo)`, `(Mono)` - **Neutral**
- Standard versions: `(Original)`, `(Album Version)`, `(Single Version)` - **Neutral**
- Radio versions: `(Radio Edit)`, `(Radio Version)` - **Neutral**
- Content ratings: `(Explicit)`, `(Clean)` - **Neutral**
- Live recordings: `(Live)`, `(Live at Wembley)`, `(Concert Version)` - **Available but penalized** (-5 penalty)
- Featuring variations: `(feat. Artist)`, `(featuring Someone)`, `(with Artist)` - **Neutral**
- Acoustic versions: `(Acoustic)` - **Context-aware** (penalized -2 unless playlist contains "acoustic/unplugged")
- Unplugged versions: `(Unplugged)` - **Context-aware** (penalized -3 unless playlist contains "acoustic/unplugged")
- Demo versions: `(Demo)` - **Available but penalized** (-3 penalty)

**❌ Still Rejected:**
- Specific remixes: `(Extended Mix)`, `(Club Mix)`, `(Dance Mix)`, `(House Mix)` - Only very specific remix types

### Source Tracks with Version Info
When the source track includes version information, matching is more permissive but still filters obvious mismatches:

- **Live matching**: Live source tracks only match live Plex tracks, and vice versa
- **Remix matching**: Source remixes can match non-remix versions, but non-remix sources won't match remix versions
- **Consistent versioning**: Major version types must be consistent between source and target

## Implementation Details

### Core Functions
- `is_acceptable_version_match(source_title, plex_title)` - Main filtering logic
- `extract_version_info(title)` - Extracts content from parentheses and brackets

### Integration Points
The version filtering is integrated into all track matching functions:
- `find_best_match()` - Standard playlist operations
- `find_best_match_for_merge()` - Playlist merging
- `PlaylistConverterThread.find_best_match()` - Streaming service imports

### Scoring System
- Title similarity: 70% weight using fuzzy string matching
- Artist similarity: 30% weight
- Minimum match threshold: 70% combined score
- Version filtering applied before scoring to eliminate inappropriate matches
- **Preference bonuses** for preferred versions:
  - Remastered versions: +3.0 to +4.0 bonus points
  - Anniversary editions: +2.0 bonus points
  - Deluxe editions: +1.0 bonus points

## Manual Search Feature
When no suitable match is found automatically, users can:
- **Manual Search**: Opens a search dialog to find tracks manually
- **Real-time search**: Search results update as you type
- **Smart pre-population**: Search field pre-filled with source track title
- **Easy selection**: Double-click or select + confirm to choose a track

## Examples

```
Source: "Alive" by Pearl Jam
✅ Matches: "Alive" (score: 100) - **Perfect match** (exact title and artist)
✅ Matches: "Alive (Remastered)" (score: 85 + 3 bonus = 88) - **Preferred**
✅ Matches: "Alive (Live)" (score: 85 - 5 penalty = 80) - **Available but lower ranked**
✅ Matches: "Alive (feat. Someone)" (score: 85) - **Good match**
❌ Rejects: "Alive (Extended Mix)" (specific remix type)

Context-Aware Acoustic Matching:
Regular playlist importing "Black" by Pearl Jam:
✅ "Black" (score: 100) - **Perfect match**
✅ "Black (Remastered)" (score: 85 + 3 = 88) - **Preferred**
✅ "Black (Acoustic)" (score: 85 - 2 = 83) - **Available but penalized**

"MTV Unplugged" playlist importing "Black" by Pearl Jam:
✅ "Black (Acoustic)" (score: 85 + 2 = 87) - **Preferred in acoustic context**
✅ "Black (Unplugged)" (score: 85 + 3 = 88) - **Most preferred in unplugged context**
✅ "Black" (score: 85) - **Good match**

Source: "No Beef" by Afrojack
✅ Matches: "No Beef (Remastered)" (gets +3 preference bonus)
✅ Matches: "No Beef" (standard version)
✅ Matches: "No Beef (Live)" (gets -5 penalty but still available)
❌ Rejects: "No Beef (Club Mix)" (specific remix type)

Source: "Song (Live)" by Artist  
✅ Matches: "Song (Live at Madison Square Garden)"
❌ Rejects: "Song" (studio version - live/non-live mismatch when source is specific)

Ranking Examples:
"Classic Track" → Ranks: "Classic Track (2021 Remaster)" > "Classic Track" > "Classic Track (Live)"
"Old Song" → Ranks: "Old Song (Remastered)" > "Old Song" > "Old Song (Acoustic)" > "Old Song (Live)"

Performance Optimizations:
- Very short titles (< 3 characters) use exact matching only to prevent false positives
- Search results limited to 100 tracks per query for performance
- Manual search limited to 50 results for usability
- Short titles require 95%+ accuracy vs 60% for normal titles
```

## User Experience Flow
1. **High confidence match (80%+)**: Auto-accepted
2. **Medium confidence (60-79%)**: User confirmation dialog with options:
   - ✅ Use This Match
   - ❌ Skip This Track  
   - 🔍 Search Manually
   - ⏭️ Skip All Low Matches
3. **No match found**: Automatic manual search dialog
4. **Manual search**: Real-time search with easy track selection

This ensures users get the track versions they expect while providing control over uncertain matches.