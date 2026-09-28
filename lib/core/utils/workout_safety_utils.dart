/// Workout safety and joint protection utilities.
///
/// Protects beginners and users with high BMI (obese >= 30.0) from
/// high-impact, spine-straining, or excessive joint-load exercises.
library;

/// Registry of contraindicated exercises mapped to their safe low-impact alternatives.
const Map<String, String> kSafeExerciseAlternatives = {
  // High-Impact Jumping -> Wall Sit (safe isometric lower body)
  'jumping_jack': 'wall_sit',
  'burpee': 'wall_sit',
  'jump_squat': 'wall_sit',
  'high_knees': 'wall_sit',

  // Full Bodyweight Load -> Knee Push-up (reduces load to ~50% with stable lever)
  'pushup': 'knee_pushup',
  'diamond_pushup': 'knee_pushup',

  // Rapid Shoulder/Wrist Shock -> Plank (static isometric neutral spine hold)
  'mountain_climber': 'plank',

  // Repetitive Spinal Flexion -> Plank (spine-neutral core engagement)
  'crunch': 'plank',
  'bicycle_crunch': 'plank',
};

/// Set of exercise IDs considered contraindicated for high-risk users.
const Set<String> kContraindicatedExerciseIds = {
  'jumping_jack',
  'burpee',
  'jump_squat',
  'high_knees',
  'pushup',
  'diamond_pushup',
  'mountain_climber',
  'crunch',
  'bicycle_crunch',
};

/// Checks if [exerciseId] is contraindicated given the user's [fitnessLevel]
/// and [bmi].
///
/// An exercise is contraindicated if it belongs to [kContraindicatedExerciseIds]
/// AND the user is either:
/// - A 'beginner' (regardless of BMI)
/// - Has BMI >= 30.0 (Obese, regardless of fitness level)
bool isExerciseContraindicated(
  String exerciseId, {
  required String fitnessLevel,
  required double? bmi,
}) {
  if (!kContraindicatedExerciseIds.contains(exerciseId)) {
    return false;
  }

  final isBeginner = fitnessLevel.trim().toLowerCase() == 'beginner';
  final isObese = bmi != null && bmi >= 30.0;

  return isBeginner || isObese;
}

/// Returns the ID of a safe, lower-impact alternative exercise for [exerciseId],
/// or `null` if none is configured or the exercise is already safe.
String? getSafeAlternativeExerciseId(String exerciseId) {
  return kSafeExerciseAlternatives[exerciseId];
}

/// Returns a localized `(title, description)` tuple for joint-safety warnings
/// based on the target [exerciseId] and [langCode].
(String, String) getLocalizedSafetyWarning(String exerciseId, String? langCode) {
  final lang = langCode ?? 'en';

  final title = switch (lang) {
    'id' => 'Perhatian Beban Sendi ⚠️',
    'es' => 'Atención: Cuidado Articular ⚠️',
    'ja' => '関節の保護注意 ⚠️',
    _ => 'Joint Safety Caution ⚠️',
  };

  final description = switch (exerciseId) {
    'jumping_jack' || 'burpee' || 'jump_squat' || 'high_knees' => switch (lang) {
      'id' =>
        'Gerakan lompatan menghasilkan beban kejut berulang pada sendi lutut, pergelangan kaki, dan tulang belakang.',
      'es' =>
        'Las fuerzas repetidas de impacto transmiten cargas pesadas al cartílago de la rodilla, tobillos y columna lumbar.',
      'ja' =>
        '着地時の衝撃が膝軟骨、足首、腰椎に繰り返し過度な負担をかけます。',
      _ =>
        'Repetitive ground reaction forces transfer extreme multi-bodyweight loads to knee cartilage, ankles, and lumbar spine.',
    },
    'pushup' || 'diamond_pushup' => switch (lang) {
      'id' =>
        'Mengangkat 65-75% beban tubuh penuh berisiko mencederai sendi bahu dan pergelangan tangan.',
      'es' =>
        'Levantar el 65-75% del peso corporal sobrecarga el manguito rotador y las muñecas.',
      'ja' =>
        '自重の65〜75%を持ち上げる動作は、腱板損傷や手首関節の過伸展リスクがあります。',
      _ =>
        'Lifting 65-75% of heavy bodyweight risks rotator cuff tears and wrist joint hyperextension.',
    },
    'mountain_climber' => switch (lang) {
      'id' =>
        'Gerakan lutut berkecepatan tinggi dapat membebani pergelangan tangan dan memicu lonjakan denyut jantung mendadak.',
      'es' =>
        'El movimiento rápido de rodillas compromete las muñecas y eleva abruptamente la frecuencia cardíaca.',
      'ja' =>
        '素早い膝の引き上げは手首に負担をかけ、急激な心拍数上昇を引き起こす可能性があります。',
      _ =>
        'High cadence knee drives compromise wrist angle and abruptly elevate heart rate beyond safe threshold.',
    },
    'crunch' || 'bicycle_crunch' => switch (lang) {
      'id' =>
        'Gerakan fleksi tulang belakang berulang memberi tekanan berlebih pada bantalan cakram lumbal.',
      'es' =>
        'La flexión espinal repetitiva genera excesiva fuerza de compresión en los discos lumbares.',
      'ja' =>
        '反復的な脊柱屈曲は、腰椎椎間板に過度な圧迫剪断力を与えます。',
      _ =>
        'Excessive lumbar disc compressive shear forces without metabolic benefit.',
    },
    _ => switch (lang) {
      'id' =>
        'Gerakan ini memberikan beban benturan tinggi atau beban tubuh penuh pada sendi lutut, pergelangan kaki, atau bahu. Pemula atau pengguna dengan berat badan berlebih disarankan menggunakan alternatif berisiko rendah.',
      'es' =>
        'Este movimiento ejerce un alto impacto o presión del peso corporal completo sobre las articulaciones de rodilla, tobillo o hombro. Se recomienda a principiantes o personas con masa corporal elevada usar alternativas de bajo impacto.',
      'ja' =>
        'この運動は膝、足首、肩関節に強い衝撃や全自重の負担をかけます。初心者や高体重の方は低負荷の代替種目を推奨します。',
      _ =>
        'This movement puts high impact or full bodyweight pressure on knee, ankle, or shoulder joints. Beginners or individuals with elevated body mass are advised to use low-impact alternatives.',
    },
  };

  return (title, description);
}
