class_name QuestResource
extends Resource


enum OrderType { UNORDERED, ORDERED }


@export var quest_name: String
@export var order_type := OrderType.UNORDERED
@export var quest_item_stack: Array
