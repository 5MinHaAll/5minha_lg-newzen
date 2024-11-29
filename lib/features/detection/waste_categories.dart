// waste_categories.dart

const wasteCategories = {
  "processable": [
    {"name": "Apple", "name_ko": "사과", "status": "처리 가능"},
    {"name": "Banana", "name_ko": "바나나", "status": "처리 가능"},
    {"name": "Rice", "name_ko": "밥", "status": "처리 가능"},
    {"name": "Tomato", "name_ko": "토마토", "status": "처리 가능"},
    {"name": "Cucumber", "name_ko": "오이", "status": "처리 가능"},
    {"name": "Fish", "name_ko": "생선", "status": "처리 가능"},
    {"name": "Meat", "name_ko": "고기", "status": "처리 가능"},
    {"name": "Bread", "name_ko": "빵", "status": "처리 가능"},
    {"name": "Pancake", "name_ko": "팬케이크", "status": "처리 가능"},
    {"name": "Tofu", "name_ko": "두부", "status": "처리 가능"},
  ],
  "caution": [
    {"name": "Banana-peel", "name_ko": "바나나 껍질", "status": "주의 필요"},
    {"name": "Apple-core", "name_ko": "사과 심", "status": "주의 필요"},
    {"name": "Drink", "name_ko": "음료", "status": "주의 필요"},
    {"name": "Potato", "name_ko": "감자", "status": "주의 필요"},
    {
      "name": "High-fiber Vegetables",
      "name_ko": "섬유질 많은 채소",
      "status": "주의 필요"
    },
    {"name": "Orange-peel", "name_ko": "오렌지 껍질", "status": "주의 필요"},
    {"name": "Shrimp", "name_ko": "새우", "status": "주의 필요"},
  ],
  "nonProcessable": [
    {"name": "Bone", "name_ko": "뼈", "status": "처리 불가"},
    {"name": "Bone-fish", "name_ko": "생선 뼈", "status": "처리 불가"},
    {"name": "Mussel-shell", "name_ko": "조개껍데기", "status": "처리 불가"},
    {"name": "Egg-shell", "name_ko": "달걀 껍질", "status": "처리 불가"},
    {"name": "Shrimp-shell", "name_ko": "새우 껍질", "status": "처리 불가"},
    {"name": "Other-waste", "name_ko": "기타 쓰레기", "status": "처리 불가"},
  ],
  "guidelines": {
    "processable": {
      "title": "투입 가능한 음식물입니다",
      "subtitle": "기본 원칙: 사람이 먹고 소화할 수 있는 것은 모두 분해 가능",
      "details": [
        "사람이 먹고 소화할 수 있는 음식물은 모두 분해가 가능합니다",
        "1일 적정량을 준수하여 투입해주세요",
        "물기를 최대한 제거 후 투입해주세요"
      ],
      "examples": [
        "과일류, 야채류",
        "익힌 고기/생선류",
        "면, 곡류",
        "씻은 상태의 김치, 된장찌개, 젓갈, 양념",
        "과자, 빵, 계란"
      ]
    },
    "caution": {
      "title": "주의가 필요한 음식물입니다",
      "subtitle": "처리 방법: 부피가 크거나 섬유질이 많은 음식은 잘게 잘라서 소량 투입",
      "details": [
        "크기를 작게 잘라서 투입해주세요",
        "한 번에 많은 양을 넣지 마세요",
        "다른 음식물과 섞어서 처리하면 더 효과적입니다",
        "제습 모드 사용 후 투입해주세요"
      ],
      "examples": ["떡, 수박껍질, 바나나 껍질", "무, 배추, 오이, 고구마"]
    },
    "nonProcessable": {
      "title": "투입이 불가능한 음식물입니다",
      "subtitle": "원칙: 딱딱하거나 분해되지 않는 물질 금지",
      "details": [
        "일반 쓰레기로 분리배출 해주세요",
        "음식물 처리기에 투입하지 마세요",
        "무리한 처리 시 기기 고장의 원인이 됩니다",
        "딱딱하거나 분해되지 않는 물질은 투입이 불가합니다"
      ],
      "examples": [
        "뼈류 (닭, 돼지, 소 등), 고기/생선 내장, 조개껍데기",
        "식용유, 고지방 음식, 염분 많은 장류",
        "야채 뿌리/껍질(양파, 생강 등), 씨앗류(복숭아, 감)",
        "청소세제, 화학약품, 의약품, 비닐, 플라스틱",
        "유리, 금속, 나무젓가락, 테이프 등"
      ]
    },
    "usage_precautions": {
      "title": "사용 시 필수 주의사항",
      "details": [
        "과투입 방지: 1일 적정량과 최대량 준수",
        "섬유질 처리: 잎채소, 열매채소는 잘게 썰어서 투입",
        "사용법 숙지: 부적절한 사용은 악취 및 고장의 원인이 됨"
      ]
    }
  }
};
