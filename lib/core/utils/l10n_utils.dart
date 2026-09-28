import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';

export '../../l10n/app_localizations.dart';

/// Extension for fast, clean access to AppLocalizations in any BuildContext.
extension AppLocalizationsX on BuildContext {
  /// Shorthand to access localized strings: `context.l10n.someString`.
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

/// Returns the active language code for the app, falling back to 'id' if
/// [AppLocalizations] is not mounted (e.g. raw [MaterialApp] in test fixtures).
String getAppLanguageCode(BuildContext context) {
  if (AppLocalizations.of(context) == null) {
    return 'id';
  }
  return Localizations.localeOf(context).languageCode;
}

/// Helper functions to localize dynamic/database content across supported locales
/// (English, Spanish, Japanese, and Indonesian).
String getLocalizedQuestTitle(String questId, String fallback, String? langCode) {
  final lang = langCode ?? 'id';
  switch (questId) {
    case 'checkin_today':
      switch (lang) {
        case 'en':
          return 'Check-in today';
        case 'ja':
          return '本日のチェックイン';
        case 'es':
          return 'Registro de hoy';
        default:
          return fallback;
      }
    case 'meditate_5min':
      switch (lang) {
        case 'en':
          return 'Meditate at least 5 minutes';
        case 'ja':
          return '最低5分間の瞑想';
        case 'es':
          return 'Meditar al menos 5 minutos';
        default:
          return fallback;
      }
    case 'workout_1':
      switch (lang) {
        case 'en':
          return 'Complete 1 workout';
        case 'ja':
          return 'ワークアウトを1回完了';
        case 'es':
          return 'Completar 1 entrenamiento';
        default:
          return fallback;
      }
    case 'log_trigger_1':
      switch (lang) {
        case 'en':
          return 'Log 1 trigger';
        case 'ja':
          return 'トリガーを1件記録';
        case 'es':
          return 'Registrar 1 detonante';
        default:
          return fallback;
      }
    case 'meditate_10min':
      switch (lang) {
        case 'en':
          return 'Meditate for 10 minutes';
        case 'ja':
          return '10分間の瞑想';
        case 'es':
          return 'Meditar 10 minutos';
        default:
          return fallback;
      }
    case 'workout_2':
      switch (lang) {
        case 'en':
          return 'Complete 2 workouts';
        case 'ja':
          return 'ワークアウトを2回完了';
        case 'es':
          return 'Completar 2 entrenamientos';
        default:
          return fallback;
      }
    case 'weekly_meditate_5days':
      switch (lang) {
        case 'en':
          return 'Meditate 5 days this week';
        case 'ja':
          return '今週5日間瞑想する';
        case 'es':
          return 'Meditar 5 días esta semana';
        default:
          return fallback;
      }
    case 'weekly_workout_3':
      switch (lang) {
        case 'en':
          return '3 workouts this week';
        case 'ja':
          return '今週3回ワークアウト';
        case 'es':
          return '3 entrenamientos esta semana';
        default:
          return fallback;
      }
    case 'weekly_checkin_all':
      switch (lang) {
        case 'en':
          return 'Check-in every day this week';
        case 'ja':
          return '今週毎日チェックイン';
        case 'es':
          return 'Registrarse todos los días esta semana';
        default:
          return fallback;
      }
    case 'weekly_meditate_60min':
      switch (lang) {
        case 'en':
          return '60 total meditation minutes this week';
        case 'ja':
          return '今週合計60分の瞑想';
        case 'es':
          return '60 minutos totales de meditación esta semana';
        default:
          return fallback;
      }
    case 'weekly_workout_5':
      switch (lang) {
        case 'en':
          return '5 total workouts this week';
        case 'ja':
          return '今週合計5回ワークアウト';
        case 'es':
          return '5 entrenamientos totales esta semana';
        default:
          return fallback;
      }
    default:
      return fallback;
  }
}

(String, String) getLocalizedAmbientTrack(
  String trackId,
  String fallbackTitle,
  String fallbackSubtitle,
  String? langCode,
) {
  final lang = langCode ?? 'id';
  switch (trackId) {
    case 'rain':
      switch (lang) {
        case 'en':
          return ('Rain', 'Gentle drizzle');
        case 'ja':
          return ('雨', '穏やかな雨音');
        case 'es':
          return ('Lluvia', 'Llovizna suave');
        default:
          return (fallbackTitle, fallbackSubtitle);
      }
    case 'waves':
      switch (lang) {
        case 'en':
          return ('Ocean Waves', 'Beach surf');
        case 'ja':
          return ('波', '打ち寄せる波');
        case 'es':
          return ('Olas', 'Oleaje de playa');
        default:
          return (fallbackTitle, fallbackSubtitle);
      }
    case 'forest':
      switch (lang) {
        case 'en':
          return ('Forest', 'Wind & birds');
        case 'ja':
          return ('森', '風と小鳥');
        case 'es':
          return ('Bosque', 'Viento y pájaros');
        default:
          return (fallbackTitle, fallbackSubtitle);
      }
    case 'campfire':
      switch (lang) {
        case 'en':
          return ('Campfire', 'Crackling wood');
        case 'ja':
          return ('焚き火', '薪のはぜる音');
        case 'es':
          return ('Fogata', 'Leña crepitante');
        default:
          return (fallbackTitle, fallbackSubtitle);
      }
    case 'lofi':
      switch (lang) {
        case 'en':
          return ('Lo-fi Ambient', 'Warm melody');
        case 'ja':
          return ('ローファイ', '温かいメロディ');
        case 'es':
          return ('Lo-fi Ambient', 'Melodía cálida');
        default:
          return (fallbackTitle, fallbackSubtitle);
      }
    case 'whitenoise':
      switch (lang) {
        case 'en':
          return ('White Noise', 'Smooth frequency');
        case 'ja':
          return ('ホワイトノイズ', '柔らかな周波数');
        case 'es':
          return ('Ruido Blanco', 'Frecuencia suave');
        default:
          return (fallbackTitle, fallbackSubtitle);
      }
    default:
      return (fallbackTitle, fallbackSubtitle);
  }
}

(String, String) getLocalizedAchievement(
  String badgeId,
  String fallbackTitle,
  String fallbackDesc,
  String? langCode,
) {
  final lang = langCode ?? 'id';
  if (lang == 'id' || lang == 'en') {
    return (fallbackTitle, fallbackDesc);
  }
  switch (badgeId) {
    case 'first_spark':
      switch (lang) {
        case 'ja':
          return ('最初の火花', '1日クリーン');
        case 'es':
          return ('Primera Chispa', '1 día limpio');
        case 'id':
          return ('Percikan Pertama', '1 hari bersih');
        default:
          return (fallbackTitle, fallbackDesc);
      }
    case 'week_warrior':
      switch (lang) {
        case 'ja':
          return ('1週間の戦士', '7日間の継続');
        case 'es':
          return ('Guerrero Semanal', 'Racha de 7 días');
        case 'id':
          return ('Pejuang Satu Pekan', 'Streak 7 hari');
        default:
          return (fallbackTitle, fallbackDesc);
      }
    case 'two_weeks':
      switch (lang) {
        case 'ja':
          return ('2週間の闘士', '14日間の継続');
        case 'es':
          return ('Luchador Quincenal', 'Racha de 14 días');
        case 'id':
          return ('Ksatria Dua Pekan', 'Streak 14 hari');
        default:
          return (fallbackTitle, fallbackDesc);
      }
    case 'lunar_cycle':
      switch (lang) {
        case 'ja':
          return ('月の満ち欠け', '30日間の継続');
        case 'es':
          return ('Ciclo Lunar', 'Racha de 30 días');
        case 'id':
          return ('Siklus Bulan', 'Streak 30 hari');
        default:
          return (fallbackTitle, fallbackDesc);
      }
    case 'solar_power':
      switch (lang) {
        case 'ja':
          return ('太陽の力', '90日間の継続');
        case 'es':
          return ('Poder Solar', 'Racha de 90 días');
        case 'id':
          return ('Kekuatan Surya', 'Streak 90 hari');
        default:
          return (fallbackTitle, fallbackDesc);
      }
    case 'zen_mind':
      switch (lang) {
        case 'ja':
          return ('禅の心', '瞑想合計100分');
        case 'es':
          return ('Mente Zen', '100 minutos de meditación en total');
        case 'id':
          return ('Pikiran Zen', 'Total 100 menit meditasi');
        default:
          return (fallbackTitle, fallbackDesc);
      }
    case 'deep_focus':
      switch (lang) {
        case 'ja':
          return ('深い集中', '瞑想合計500分');
        case 'es':
          return ('Enfoque Profundo', '500 minutos de meditación en total');
        case 'id':
          return ('Fokus Mendalam', 'Total 500 menit meditasi');
        default:
          return (fallbackTitle, fallbackDesc);
      }
    case 'iron_will':
      switch (lang) {
        case 'ja':
          return ('鋼の意志', 'ワークアウト50回達成');
        case 'es':
          return ('Voluntad de Hierro', '50 entrenamientos completados');
        case 'id':
          return ('Tekad Baja', 'Selesaikan 50 workout');
        default:
          return (fallbackTitle, fallbackDesc);
      }
    case 'marathon':
      switch (lang) {
        case 'ja':
          return ('マラソン', 'ワークアウト100回達成');
        case 'es':
          return ('Maratón', '100 entrenamientos completados');
        case 'id':
          return ('Maraton', 'Selesaikan 100 workout');
        default:
          return (fallbackTitle, fallbackDesc);
      }
    case 'early_bird':
      switch (lang) {
        case 'ja':
          return ('早起き鳥', '午前8時前に7日連続チェックイン');
        case 'es':
          return ('Madrugador', 'Registro antes de las 8 AM, 7 días seguidos');
        case 'id':
          return ('Bangun Pagi', 'Check-in sebelum jam 8 pagi, 7 hari berturut-turut');
        default:
          return (fallbackTitle, fallbackDesc);
      }
    case 'night_owl':
      switch (lang) {
        case 'ja':
          return ('夜更かしフクロウ', '夜10時以降に5回瞑想');
        case 'es':
          return ('Búho Nocturno', 'Meditar después de las 10 PM, 5 veces');
        case 'id':
          return ('Burung Hantu', 'Meditasi setelah jam 10 malam, 5 kali');
        default:
          return (fallbackTitle, fallbackDesc);
      }
    case 'consistency':
      switch (lang) {
        case 'ja':
          return ('継続の王者', '30日連続チェックイン');
        case 'es':
          return ('Rey de la Constancia', '30 registros diarios consecutivos');
        case 'id':
          return ('Raja Konsistensi', '30 hari check-in berturut-turut');
        default:
          return (fallbackTitle, fallbackDesc);
      }
    case 'explorer':
      switch (lang) {
        case 'ja':
          return ('探求者', '全6種類の環境音を試す');
        case 'es':
          return ('Explorador', 'Probar los 6 sonidos ambientales');
        case 'id':
          return ('Penjelajah', 'Coba seluruh 6 suara suasana');
        default:
          return (fallbackTitle, fallbackDesc);
      }
    case 'full_body':
      switch (lang) {
        case 'ja':
          return ('フルボディ', '全ワークアウトルーティンを各1回以上完了');
        case 'es':
          return ('Cuerpo Completo', 'Completar todas las rutinas al menos una vez');
        case 'id':
          return ('Seluruh Tubuh', 'Selesaikan semua rutinitas workout minimal sekali');
        default:
          return (fallbackTitle, fallbackDesc);
      }
    case 'trigger_aware':
      switch (lang) {
        case 'ja':
          return ('トリガー察知', 'トリガーを20回記録');
        case 'es':
          return ('Consciente de Detonantes', 'Registrar 20 detonantes');
        case 'id':
          return ('Sadar Pemicu', 'Catat 20 pemicu (trigger)');
        default:
          return (fallbackTitle, fallbackDesc);
      }
    case 'bouncer':
      switch (lang) {
        case 'ja':
          return ('リカバリーの達人', 'スリップ後24時間以内に再開');
        case 'es':
          return ('Rebote Rápido', 'Reanudar racha dentro de 24h tras recaída');
        case 'id':
          return ('Bangkit Cepat', 'Lanjutkan streak dalam waktu 24 jam setelah relapse');
        default:
          return (fallbackTitle, fallbackDesc);
      }
    case 'level_10':
      switch (lang) {
        case 'ja':
          return ('若木', 'レベル10到達');
        case 'es':
          return ('Brote', 'Alcanzar el nivel 10');
        case 'id':
          return ('Tunas Baru', 'Capai level 10');
        default:
          return (fallbackTitle, fallbackDesc);
      }
    case 'level_25':
      switch (lang) {
        case 'ja':
          return ('大樹', 'レベル25到達');
        case 'es':
          return ('Roble Fuerte', 'Alcanzar el nivel 25');
        case 'id':
          return ('Pohon Tangguh', 'Capai level 25');
        default:
          return (fallbackTitle, fallbackDesc);
      }
    case 'level_50':
      switch (lang) {
        case 'ja':
          return ('完全な再構築', 'レベル50到達（最大）');
        case 'es':
          return ('Totalmente Reconectado', 'Alcanzar el nivel 50 (máximo)');
        case 'id':
          return ('Terhubung Sempurna', 'Capai level 50 (maksimal)');
        default:
          return (fallbackTitle, fallbackDesc);
      }
    case 'quest_master':
      switch (lang) {
        case 'ja':
          return ('クエストマスター', 'デイリークエスト累計50回完了');
        case 'es':
          return ('Maestro de Misiones', 'Completar 50 misiones diarias en total');
        case 'id':
          return ('Master Misi', 'Selesaikan total 50 misi harian');
        default:
          return (fallbackTitle, fallbackDesc);
      }
    default:
      return (fallbackTitle, fallbackDesc);
  }
}

(String, String) getLocalizedExerciseDetails(
  String exerciseId,
  String fallbackTarget,
  String fallbackDesc,
  String? langCode,
) {
  final lang = langCode ?? 'id';
  switch (exerciseId) {
    case 'pushup':
      switch (lang) {
        case 'en':
          return ('Chest & Triceps', 'Basic upper body exercise to strengthen chest, shoulders, and triceps.');
        case 'ja':
          return ('胸・上腕三頭筋', '胸、肩、上腕三頭筋を鍛える上半身の基本エクササイズ。');
        case 'es':
          return ('Pecho y tríceps', 'Ejercicio básico de tren superior para fortalecer pecho, hombros y tríceps.');
        default:
          return (fallbackTarget, fallbackDesc);
      }
    case 'knee_pushup':
      switch (lang) {
        case 'en':
          return ('Chest & Arms', 'Knee-supported push-up variation to build foundational strength.');
        case 'ja':
          return ('胸・腕', '膝をついて基礎筋力を養う腕立て伏せのバリエーション。');
        case 'es':
          return ('Pecho y brazos', 'Variación de flexión apoyando las rodillas para desarrollar fuerza básica.');
        default:
          return (fallbackTarget, fallbackDesc);
      }
    case 'diamond_pushup':
      switch (lang) {
        case 'en':
          return ('Triceps & Inner Chest', 'Hands in a diamond shape under chest for maximum triceps activation.');
        case 'ja':
          return ('上腕三頭筋・胸部内側', '胸の下で手をダイヤモンド形にして上腕三頭筋を最大限に刺激します。');
        case 'es':
          return ('Tríceps y pecho interno', 'Manos en forma de diamante debajo del pecho para máxima activación del tríceps.');
        default:
          return (fallbackTarget, fallbackDesc);
      }
    case 'pike_pushup':
      switch (lang) {
        case 'en':
          return ('Shoulders & Upper Back', 'Upper body pike position targeting shoulders and upper back.');
        case 'ja':
          return ('肩・背中上部', '体を逆V字にして肩と背中上部の筋力を鍛えます。');
        case 'es':
          return ('Hombros y espalda alta', 'Cuerpo en triángulo invertido para entrenar la fuerza de hombros.');
        default:
          return (fallbackTarget, fallbackDesc);
      }
    case 'squat':
      switch (lang) {
        case 'en':
          return ('Quads & Glutes', 'Fundamental lower body movement strengthening quads and glutes.');
        case 'ja':
          return ('太もも・お尻', '大腿四頭筋とお尻を強化する下半身の基本動作。');
        case 'es':
          return ('Cuádriceps y glúteos', 'Movimiento fundamental de tren inferior para fortalecer cuádriceps y glúteos.');
        default:
          return (fallbackTarget, fallbackDesc);
      }
    case 'lunge':
      switch (lang) {
        case 'en':
          return ('Quads & Balance', 'Steady forward steps training leg stability, quads, and hips.');
        case 'ja':
          return ('大腿前部・バランス', '脚の安定性と大腿部、股関節を鍛える前進ステップ。');
        case 'es':
          return ('Cuádriceps y equilibrio', 'Pasos hacia adelante para entrenar la estabilidad de piernas, cuádriceps y caderas.');
        default:
          return (fallbackTarget, fallbackDesc);
      }
    case 'jump_squat':
      switch (lang) {
        case 'en':
          return ('Explosive Leg Power', 'Explosive squats with jumps for leg power and calorie burn.');
        case 'ja':
          return ('脚の瞬発力・ふくらはぎ', 'ジャンプを伴う爆発的なスクワットで脚力強化と脂肪燃焼を促進。');
        case 'es':
          return ('Potencia de piernas y pantorrillas', 'Sentadilla explosiva con salto para potencia en piernas y quema calórica.');
        default:
          return (fallbackTarget, fallbackDesc);
      }
    case 'wall_sit':
      switch (lang) {
        case 'en':
          return ('Quad Endurance', 'Hold a sitting stance against a wall for isometric endurance.');
        case 'ja':
          return ('大腿前部の持久力', '壁にもたれて座る姿勢を維持し、等尺性筋持久力を鍛えます。');
        case 'es':
          return ('Resistencia de cuádriceps', 'Mantén la postura sentada contra la pared para resistencia isométrica.');
        default:
          return (fallbackTarget, fallbackDesc);
      }
    case 'plank':
      switch (lang) {
        case 'en':
          return ('Core & Posture', 'Hold straight with elbows to strengthen core and posture.');
        case 'ja':
          return ('体幹・姿勢', '肘をついて体を一直線に保ち、体幹全体を強化します。');
        case 'es':
          return ('Core y postura', 'Mantén el cuerpo recto sobre los codos para fortalecer el core y la postura.');
        default:
          return (fallbackTarget, fallbackDesc);
      }
    case 'crunch':
      switch (lang) {
        case 'en':
          return ('Upper Abs', 'Lift upper back off the floor to activate upper abs.');
        case 'ja':
          return ('腹筋上部', '床から背面上部を持ち上げて腹筋上部を刺激します。');
        case 'es':
          return ('Abdomen superior', 'Eleva la espalda superior del suelo para activar el abdomen superior.');
        default:
          return (fallbackTarget, fallbackDesc);
      }
    case 'mountain_climber':
      switch (lang) {
        case 'en':
          return ('Lower Abs & Cardio', 'Drive knees alternatively from push-up position for core and cardio.');
        case 'ja':
          return ('腹筋下部・体幹有酸素', '腕立て伏せの姿勢から素早く交互に膝を引き上げ、体幹と有酸素を鍛えます。');
        case 'es':
          return ('Abdomen inferior y cardio', 'Desde posición de flexión lleva rodillas al pecho alternadamente, trabajando core y cardio.');
        default:
          return (fallbackTarget, fallbackDesc);
      }
    case 'bicycle_crunch':
      switch (lang) {
        case 'en':
          return ('Obliques', 'Pedaling motion while lying down to target obliques.');
        case 'ja':
          return ('腹斜筋（脇腹）', '仰向けで自転車を漕ぐような動きで腹斜筋を集中刺激します。');
        case 'es':
          return ('Oblicuos', 'Movimiento de pedaleo acostado para trabajar los oblicuos.');
        default:
          return (fallbackTarget, fallbackDesc);
      }
    case 'jumping_jack':
      switch (lang) {
        case 'en':
          return ('Cardio & Full Body', 'Jump opening legs and arms overhead for cardio warm-up.');
        case 'ja':
          return ('有酸素・全身', '手足を開閉して跳ぶ有酸素ウォーミングアップ。');
        case 'es':
          return ('Cardiovascular y cuerpo completo', 'Salta abriendo piernas y brazos sobre la cabeza para calentamiento cardiovascular.');
        default:
          return (fallbackTarget, fallbackDesc);
      }
    case 'high_knees':
      switch (lang) {
        case 'en':
          return ('Stamina & Hip Flexors', 'Jog in place lifting knees dynamically up to waist height.');
        case 'ja':
          return ('持久力・腸腰筋', '腰の高さまでリズミカルに膝を上げるその場ランニング。');
        case 'es':
          return ('Resistencia y flexores de cadera', 'Corre en el sitio levantando las rodillas a la altura de la cintura de forma dinámica.');
        default:
          return (fallbackTarget, fallbackDesc);
      }
    case 'burpee':
      switch (lang) {
        case 'en':
          return ('Full Body & Stamina', 'Full-body squat, plank, push-up, and jump sequence.');
        case 'ja':
          return ('全身・スタミナ', 'スクワット、プランク、腕立て、ジャンプを一連で行う全身運動。');
        case 'es':
          return ('Cuerpo completo y resistencia', 'Secuencia de sentadilla, plancha, flexión y salto de cuerpo entero.');
        default:
          return (fallbackTarget, fallbackDesc);
      }
    default:
      return (fallbackTarget, fallbackDesc);
  }
}

String getLocalizedExerciseUnit(String unit, String? langCode) {
  final lang = langCode ?? 'id';
  if (unit.toLowerCase().contains('sisi') || unit.toLowerCase().contains('side')) {
    switch (lang) {
      case 'en':
        return 'Reps / side';
      case 'ja':
        return '回 / 側';
      case 'es':
        return 'Reps / lado';
      default:
        return 'Repetisi / sisi';
    }
  }
  if (unit.toLowerCase().contains('detik') || unit.toLowerCase().contains('sec')) {
    switch (lang) {
      case 'en':
      case 'es':
        return 's';
      case 'ja':
        return '秒';
      default:
        return 'Detik';
    }
  }
  switch (lang) {
    case 'en':
    case 'es':
      return 'Reps';
    case 'ja':
      return '回';
    default:
      return 'Repetisi';
  }
}

String getLocalizedDifficulty(String diff, String? langCode) {
  final lang = langCode ?? 'id';
  if (lang == 'id' || lang == 'en') return diff;
  switch (diff.toLowerCase()) {
    case 'beginner':
    case 'pemula':
      switch (lang) {
        case 'ja':
          return '初級';
        case 'es':
          return 'Principiante';
        case 'id':
          return 'Pemula';
        default:
          return 'Beginner';
      }
    case 'intermediate':
    case 'menengah':
      switch (lang) {
        case 'ja':
          return '中級';
        case 'es':
          return 'Intermedio';
        case 'id':
          return 'Menengah';
        default:
          return 'Intermediate';
      }
    default:
      return diff;
  }
}

String getLocalizedCategory(String cat, String? langCode) {
  final lang = langCode ?? 'id';
  switch (cat.toLowerCase()) {
    case 'upper':
      switch (lang) {
        case 'ja':
          return '上半身';
        case 'es':
          return 'Superior';
        default:
          return 'Upper';
      }
    case 'lower':
      switch (lang) {
        case 'ja':
          return '下半身';
        case 'es':
          return 'Inferior';
        default:
          return 'Lower';
      }
    case 'core':
      switch (lang) {
        case 'ja':
          return '体幹';
        default:
          return 'Core';
      }
    case 'cardio':
      switch (lang) {
        case 'ja':
          return '有酸素';
        default:
          return 'Cardio';
      }
    default:
      return cat;
  }
}

(String, String) getLocalizedRoutine(
  String routineId,
  String fallbackName,
  String fallbackSubtitle,
  String? langCode,
) {
  final lang = langCode ?? 'id';
  switch (routineId) {
    case 'morning_energy':
      switch (lang) {
        case 'en':
          return ('Morning Energy', 'Nerve activation & posture');
        case 'ja':
          return ('モーニングエナジー', '神経活性化と姿勢改善');
        case 'es':
          return ('Energía Matutina', 'Activación nerviosa y postura');
        default:
          return (fallbackName, fallbackSubtitle);
      }
    case 'full_body_burn':
      switch (lang) {
        case 'en':
          return ('Full Body Burn', 'Strength & endurance');
        case 'ja':
          return ('全身バーン', '筋力と持久力アップ');
        case 'es':
          return ('Quema de Cuerpo Completo', 'Fuerza y resistencia');
        default:
          return (fallbackName, fallbackSubtitle);
      }
    case 'core_crusher':
      switch (lang) {
        case 'en':
          return ('Core Crusher', 'Core muscle strength');
        case 'ja':
          return ('コアクラッシャー', '体幹筋力強化');
        case 'es':
          return ('Triturador de Core', 'Fuerza de músculos del core');
        default:
          return (fallbackName, fallbackSubtitle);
      }
    default:
      return (fallbackName, fallbackSubtitle);
  }
}

String getLocalizedTrigger(String trigger, String? langCode) {
  final lang = langCode ?? 'id';
  switch (trigger.toLowerCase()) {
    case 'stres':
    case 'stress':
      switch (lang) {
        case 'ja':
          return 'ストレス';
        case 'es':
          return 'Estrés';
        case 'en':
          return 'Stress';
        default:
          return 'Stres';
      }
    case 'bosan':
    case 'boredom':
      switch (lang) {
        case 'ja':
          return '退屈';
        case 'es':
          return 'Aburrimiento';
        case 'en':
          return 'Boredom';
        default:
          return 'Bosan';
      }
    case 'kelelahan':
    case 'fatigue':
      switch (lang) {
        case 'ja':
          return '疲労';
        case 'es':
          return 'Fatiga';
        case 'en':
          return 'Fatigue';
        default:
          return 'Kelelahan';
      }
    case 'sosial media':
    case 'social media':
      switch (lang) {
        case 'ja':
          return 'SNS';
        case 'es':
          return 'Redes sociales';
        case 'en':
          return 'Social Media';
        default:
          return 'Sosial Media';
      }
    case 'kesepian':
    case 'loneliness':
      switch (lang) {
        case 'ja':
          return '孤独';
        case 'es':
          return 'Soledad';
        case 'en':
          return 'Loneliness';
        default:
          return 'Kesepian';
      }
    case 'lainnya':
    case 'other':
      switch (lang) {
        case 'ja':
          return 'その他';
        case 'es':
          return 'Otro';
        case 'en':
          return 'Other';
        default:
          return 'Lainnya';
      }
    default:
      return trigger;
  }
}

String getLocalizedBreathingPhase(String action, String fallback, String? langCode) {
  final lang = langCode ?? 'id';
  switch (action.toLowerCase()) {
    case 'inhale':
      switch (lang) {
        case 'en':
          return 'Inhale...';
        case 'ja':
          return '息を吸って...';
        case 'es':
          return 'Inhala...';
        default:
          return 'Tarik napas...';
      }
    case 'hold':
      switch (lang) {
        case 'en':
          return 'Hold...';
        case 'ja':
          return '息を止めて...';
        case 'es':
          return 'Mantén...';
        default:
          return 'Tahan...';
      }
    case 'exhale':
      switch (lang) {
        case 'en':
          return 'Exhale...';
        case 'ja':
          return '息を吐いて...';
        case 'es':
          return 'Exhala...';
        default:
          return 'Buang napas...';
      }
    default:
      return fallback;
  }
}

String getLocalizedBrainStageDescription(String stage, String fallback, String? langCode) {
  final lang = langCode ?? 'id';
  switch (stage.toLowerCase()) {
    case 'dormant':
      switch (lang) {
        case 'en':
          return 'Old patterns begin to rest. New neural pathways prepare to grow.';
        case 'ja':
          return '古い習慣が休息に入ります。新しい神経回路が芽生える準備をしています。';
        case 'es':
          return 'Los viejos patrones comienzan a descansar. Nuevas vías neuronales se preparan para crecer.';
        default:
          return fallback;
      }
    case 'awakening':
      switch (lang) {
        case 'en':
          return 'New sparks of mindfulness connect and illuminate gradually.';
        case 'ja':
          return '新しい気づきの点が繋がり、静かに輝き始めます。';
        case 'es':
          return 'Nuevos destellos de conciencia se conectan e iluminan gradualmente.';
        default:
          return fallback;
      }
    case 'growing':
      switch (lang) {
        case 'en':
          return 'New synaptic connections grow stronger, stable, and disciplined.';
        case 'ja':
          return '新しいシナプス結合がより強く、安定して規律正しく形成されます。';
        case 'es':
          return 'Nuevas conexiones sinápticas se fortalecen, estabilizan y forman con orden.';
        default:
          return fallback;
      }
    case 'thriving':
      switch (lang) {
        case 'en':
          return 'Positive neural networks thrive; focus and calm soar.';
        case 'ja':
          return '前向きな神経回路が発達し、集中力と落ち着きが飛躍的に向上します。';
        case 'es':
          return 'Las redes neuronales positivas prosperan, el enfoque y la calma aumentan.';
        default:
          return fallback;
      }
    case 'transcendent':
      switch (lang) {
        case 'en':
          return 'Recovery pathways fully integrated. Your brain has evolved!';
        case 'ja':
          return '回復回路が完全に統合されました。あなたの脳は進化を遂げました！';
        case 'es':
          return 'Vías de recuperación totalmente integradas. ¡Tu cerebro ha evolucionado!';
        default:
          return fallback;
      }
    default:
      return fallback;
  }
}

(String, String) getLocalizedBreathingPattern(
  String id,
  String fallbackTitle,
  String fallbackSubtitle,
  String? langCode,
) {
  final lang = langCode ?? 'id';
  switch (id) {
    case 'box':
      switch (lang) {
        case 'en':
          return ('Box', '4-4-4-4');
        case 'ja':
          return ('ボックス', '4-4-4-4');
        case 'es':
          return ('Caja', '4-4-4-4');
        default:
          return ('Box', '4-4-4-4');
      }
    case '478':
      switch (lang) {
        case 'en':
          return ('4-7-8', 'Relax');
        case 'ja':
          return ('4-7-8', 'リラックス');
        case 'es':
          return ('4-7-8', 'Relajación');
        default:
          return ('4-7-8', 'Rileks');
      }
    default:
      return (fallbackTitle, fallbackSubtitle);
  }
}

