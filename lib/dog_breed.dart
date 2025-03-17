class DogBreed {
  static const Map<String, String> characteristics = {
    'bangkaew': 'ซื่อสัตย์ กล้าหาญ ตื่นตัว',
    'beagle': 'เป็นมิตร ขี้สงสัย ชอบสำรวจ',
    'chihuahua': 'กล้าหาญ มีชีวิตชีวา ซื่อสัตย์',
    'golden retrever': 'เป็นมิตร อ่อนโยน ฉลาด',
    'labrador retrever': 'เป็นมิตร เข้ากับคนง่าย ฉลาด',
    'pomeranian': 'ขี้เล่น มีชีวิตชีวา ฉลาด',
    'shih tzu': 'เป็นมิตร อ่อนโยน ขี้ประจบ',
  };

  static const Map<String, String> careInstructions = {
    'bangkaew': 'ต้องการการออกกำลังกายปานกลาง ดูแลขนสั้น',
    'beagle': 'ต้องการการออกกำลังกายสูง ดูแลขนสั้น',
    'chihuahua': 'ต้องการการออกกำลังกายน้อย ดูแลขนตามประเภท',
    'golden retrever': 'ต้องการการออกกำลังกายสูง ดูแลขนยาว',
    'labrador retrever': 'ต้องการการออกกำลังกายสูง ดูแลขนสั้น',
    'pomeranian': 'ต้องการการออกกำลังกายปานกลาง ดูแลขนยาว',
    'shih tzu': 'ต้องการการออกกำลังกายน้อย ดูแลขนยาว',
  };

  static String getCharacteristics(String breed) {
    return characteristics[breed] ?? 'ไม่พบข้อมูล';
  }

  static String getCareInstructions(String breed) {
    return careInstructions[breed] ?? 'ไม่พบข้อมูล';
  }
}