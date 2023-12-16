
/obj/item/storage/box/m56_system
	name = "\improper M56 smartgun system case"
	desc = "A large case containing an M56B Smartgun, M56 combat harness, head mounted sight and powerpack.\nDrag this sprite into you to open it up! NOTE: You cannot put items back inside this case."
	icon = 'icons/obj/items/storage.dmi'
	icon_state = "kit_case"
	w_class = SIZE_HUGE
	storage_slots = 4
	slowdown = 1
	can_hold = list() //Nada. Once you take the stuff out it doesn't fit back in.
	foldable = null

/obj/item/storage/box/m56_system/Initialize()
	. = ..()
	new /obj/item/clothing/glasses/night/m56_goggles(src)
	new /obj/item/weapon/gun/smartgun(src)
	new /obj/item/smartgun_battery(src)
	new /obj/item/clothing/suit/storage/marine/smartgunner(src)
	update_icon()

/obj/item/storage/box/m56_system/update_icon()
	if(overlays.len)
		overlays.Cut()
	if(contents.len)
		icon_state = "kit_case"
		overlays += image(icon, "smartgun")
	else
		icon_state = "kit_case_e"

/obj/item/storage/box/m56c_system
	name = "\improper M56C smartgun system case"
	desc = "A large case containing an M56C Smartgun, M56 combat harness, head mounted sight, M280 Smartgunner Drum Belt and powerpack.\nDrag this sprite into you to open it up! NOTE: You cannot put items back inside this case."
	icon = 'icons/obj/items/storage.dmi'
	icon_state = "kit_case"
	w_class = SIZE_HUGE
	storage_slots = 5
	slowdown = 1
	can_hold = list() //Nada. Once you take the stuff out it doesn't fit back in.
	foldable = null

/obj/item/storage/box/m56c_system/Initialize()
	. = ..()
	new /obj/item/clothing/glasses/night/m56_goggles(src)
	new /obj/item/weapon/gun/smartgun/co(src)
	new /obj/item/smartgun_battery(src)
	new /obj/item/clothing/suit/storage/marine/smartgunner(src)
	new /obj/item/storage/belt/marine/smartgunner(src)
	update_icon()

/obj/item/storage/box/m56c_system/update_icon()
	if(overlays.len)
		overlays.Cut()
	if(contents.len)
		icon_state = "kit_case"
		overlays += image(icon, "smartgun")
	else
		icon_state = "kit_case_e"

/obj/item/storage/box/m56_dirty_system
	name = "\improper M56D 'Dirty' smartgun system case"
	desc = "A large case containing an M56D 'Dirty' Smartgun, M56D PMC combat harness and helmet, head mounted sight, M280 Smartgunner Drum Belt and powerpack.\nDrag this sprite into you to open it up! NOTE: You cannot put items back inside this case."
	icon = 'icons/obj/items/storage.dmi'
	icon_state = "kit_case"
	w_class = SIZE_HUGE
	storage_slots = 6
	slowdown = 1
	can_hold = list() //Nada. Once you take the stuff out it doesn't fit back in.
	foldable = null

/obj/item/storage/box/m56_dirty_system/Initialize()
	. = ..()
	new /obj/item/clothing/glasses/night/m56_goggles(src)
	new /obj/item/weapon/gun/smartgun/dirty(src)
	new /obj/item/smartgun_battery(src)
	new /obj/item/clothing/suit/storage/marine/smartgunner/veteran/pmc(src)
	new /obj/item/clothing/head/helmet/marine/veteran/pmc/gunner(src)
	new /obj/item/storage/belt/gun/smartgunner/pmc/full(src)
	update_icon()

/obj/item/storage/box/m56_dirty_system/update_icon()
	if(overlays.len)
		overlays.Cut()
	if(contents.len)
		icon_state = "kit_case"
		overlays += image(icon, "smartgun")
	else
		icon_state = "kit_case_e"

/obj/item/plasmagun_powerpack
	name = "\improper M78 Phased-plasma Infantry Gun battery bank"
	desc = "A heavy reinforced backpack with support equipment and power cells for the M56 Smartgun System."
	icon = 'icons/obj/items/clothing/backpacks.dmi'
	icon_state = "d_marinesatch_techi"
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = 2048
	w_class = SIZE_HUGE
	var/obj/item/cell/pcell = null
	var/reloading = 0

/obj/item/plasmagun_powerpack/Initialize(mapload, ...)
	. = ..()
	pcell = new /obj/item/cell/hydrogen_fuel_cell(src)

/obj/item/plasmagun_powerpack/Destroy()
	. = ..()
	QDEL_NULL(pcell)


/obj/item/plasmagun_powerpack/attackby(obj/item/A as obj, mob/user as mob)
	if(istype(A,/obj/item/cell/hydrogen_fuel_cell))
		var/obj/item/cell/hydrogen_fuel_cell = A
		visible_message("[user.name] swaps out the hydrogen fuel cell in the [src.name].","You swap out the hydrogen fuel cell in the [src] and drop the old one.")
		to_chat(user, "The new cell contains: [c.charge] power.")
		pcell.forceMove(get_turf(user))
		pcell = c
		user.drop_inv_item_to_loc(c, src)
		playsound(src,'sound/machines/click.ogg', 25, 1)
	else
		..()

/obj/item/plasmagun_powerpack/get_examine_text(mob/user)
	. = ..()
	if (pcell && get_dist(user, src) <= 1)
		. += "A small gauge in the corner reads: Power: [pcell.charge] / [pcell.maxcharge]."

/obj/item/plasmagun_powerpack/proc/drain_plasmagun_powerpack(drain = 0, /obj/item/cell/hydrogen_fuel_cell)
	var/actual_drain = (rand(drain/2,drain)/25)
	if(c && c.charge > 0)
		if(c.charge > actual_drain)
			c.charge -= actual_drain
		else
			c.charge = 0
			to_chat(usr, SPAN_WARNING("[src] emits a low power warning and immediately shuts down!"))
		return TRUE
	if(!c || c.charge == 0)
		to_chat(usr, SPAN_WARNING("[src] emits a low power warning and immediately shuts down!"))
		return FALSE
	return FALSE
