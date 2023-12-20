
/obj/item/techtree_advanced_weapon_kit
	name = "advanced weapon kit"
	desc = "It seems to be a kit to choose an advanced weapon"

	icon = 'icons/obj/items/items.dmi'
	icon_state = "wrench"

	var/gun_type = /obj/item/weapon/gun/shotgun/pump
	var/ammo_type = /obj/item/ammo_magazine/shotgun/buckshot
	var/ammo_type_count = 3


/obj/item/techtree_advanced_weapon_kit/attack_self(mob/user)
	if(!ishuman(user))
		return ..()
	var/mob/living/carbon/human/H = user

	new gun_type(get_turf(H))
	for (var/i in 1 to ammo_type_count)
		new ammo_type(get_turf(H))

	qdel(src)

/obj/item/techtree_advanced_weapon_kit/phased_plasma_infantry_gun
	name = "advanced weapon kit"
	desc = "It seems to be a kit to choose an advanced weapon"

	icon = 'icons/obj/items/items.dmi'
	icon_state = "wrench"

	gun_type = /obj/item/weapon/gun/rifle/phased_plasma_infantry_gun
	ammo_type = /obj/item/ammo_magazine/phased_plasma_infantry_gun
	ammo_type_count = 5


/obj/item/weapon/gun/rifle/phased_plasma_infantry_gun
	name = "\improper Phased-Plasma Infantry Gun"
	desc = "idk what to put here i just got tired of its old description lmao"
	icon_state = "m42a"
	item_state = "m42a"
	unacidable = TRUE
	indestructible = 1
	muzzle_flash = "muzzle_energy"
	fire_sound = 'sound/weapons/gun_sniper.ogg'
	current_mag = /obj/item/ammo_magazine/phased_plasma_infantry_gun
	force = 12
	wield_delay = WIELD_DELAY_HORRIBLE //Ends up being 1.6 seconds due to scope
	zoomdevicename = "scope"
	attachable_allowed = list()
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_WIELDED_FIRING_ONLY
	map_specific_decoration = FALSE
	actions_types = list(/datum/action/item_action/phased_plasma_infantry_gun_start_charge, /datum/action/item_action/phased_plasma_infantry_gun_abort_charge)
	var/drain = 1000
	var/powerpack = null

	// Hellpullverizer ready or not??
	var/charged = FALSE


/obj/item/weapon/gun/rifle/phased_plasma_infantry_gun/able_to_fire()
	return charged

/obj/item/weapon/gun/rifle/phased_plasma_infantry_gun/proc/start_charging(user)
	playsound(user, 'sound/weapons/plasmaguncharge.ogg', 25, 0)
	if (charged)
		to_chat(user, SPAN_WARNING("Your Phased-plasma infantry Gun is already charged."))
		return

	to_chat(user, SPAN_WARNING("You start charging your Phased-plasma infantry Gun."))
	if (!do_after(user, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		to_chat(user, SPAN_WARNING("You stop charging your Phased-plasma infantry Gun."))
		return

	to_chat(user, SPAN_WARNING("You finish charging your Phased-plasma infantry Gun."))

	charged = TRUE
	return

/obj/item/weapon/gun/rifle/phased_plasma_infantry_gun/on_enter_storage()
	if (charged)
		abort_charge()
	. = ..()

/obj/item/weapon/gun/rifle/phased_plasma_infantry_gun/proc/abort_charge(user)
	if (!charged)
		return
	charged = FALSE
	if (user)
		to_chat(user, SPAN_WARNING("You depower your Phased-plasma infantry Gun to store it."))
	return

/obj/item/weapon/gun/rifle/phased_plasma_infantry_gun/handle_starting_attachment()
	..()
	var/obj/item/attachable/scope/S = new(src)
	S.hidden = TRUE
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.Attach(src)
	update_attachable(S.slot)

/obj/item/weapon/gun/rifle/phased_plasma_infantry_gun/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_6*5)
	set_burst_amount(BURST_AMOUNT_TIER_1)
	accuracy_mult = BASE_ACCURACY_MULT * 3 //you HAVE to be able to hit
	scatter = SCATTER_AMOUNT_TIER_8
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_5

/obj/item/weapon/gun/rifle/phased_plasma_infantry_gun/unique_action(mob/user)
	if (in_chamber)
		to_chat(user, SPAN_WARNING("There's already a round chambered!"))
		return

	var/result = load_into_chamber()
	if (result)
		to_chat(user, SPAN_WARNING("You run the bolt on [src], chambering a round!"))
	else
		to_chat(user, SPAN_WARNING("You run the bolt on [src], but it's out of rounds!"))

// normally, ready_in_chamber gets called by this proc. However, it never gets called because we override.
// so we don't need to override ready_in_chamber, which is what makes the bullet and puts it in the chamber var.
/obj/item/weapon/gun/rifle/phased_plasma_infantry_gun/reload_into_chamber(mob/user)
	charged = FALSE
	in_chamber = null // blackpilled again
	return null

/datum/action/item_action/phased_plasma_infantry_gun_start_charge
	name = "Start Charging"

/datum/action/item_action/phased_plasma_infantry_gun_start_charge/action_activate()
	if (target)
		var/obj/item/weapon/gun/rifle/phased_plasma_infantry_gun/TR = target
		TR.start_charging(owner)

/datum/action/item_action/phased_plasma_infantry_gun_abort_charge
	name = "Abort Charge"

/datum/action/item_action/phased_plasma_infantry_gun_abort_charge/action_activate()
	if (target)
		var/obj/item/weapon/gun/rifle/phased_plasma_infantry_gun/TR = target
		TR.abort_charge(owner)

/obj/item/ammo_magazine/phased_plasma_infantry_gun
	name = "\improper Phased-plasma Infantry Gun ammunition canister"
	desc = "A magazine ammo for the poggers Railgun."
	caliber = "1x1cm Cadmium Telluride pellets"
	handful_state = "vulture_bullet"
	icon_state = "cadcan" //basing this off of a devinart photo, no idea how accurate it is but you try making a canister of cadmium telluride pellets, its not that easy lmao
	w_class = SIZE_LARGE
	flags_magazine = AMMUNITION_CANNOT_REMOVE_BULLETS
	max_rounds = 30
	default_ammo = /datum/ammo/rocket/ap/anti_tank/pig
	gun_type = /obj/item/weapon/gun/rifle/phased_plasma_infantry_gun

/datum/ammo/rocket/ap/anti_tank/pig
	name = "Cadmium Telluride pellet"
	damage_falloff = 0
	flags_ammo_behavior = AMMO_BALLISTIC|AMMO_SNIPER|AMMO_IGNORE_COVER
	accurate_range_min = 4
	icon_state = "emitter"
	accuracy = HIT_ACCURACY_TIER_8
	accurate_range = 32
	max_range = 32
	scatter = 0
	damage = 3*100
	penetration= ARMOR_PENETRATION_TIER_10
	shell_speed = AMMO_SPEED_TIER_6
	damage_falloff = 0

/datum/ammo/bullet/sniper/railgun/on_hit_mob(mob/M, _unused)
	if (isxeno(M))
		M.apply_effect(1, SLOW)

/obj/item/plasmagun_powerpack
	name = "\improper M78 Phased-plasma Infantry Gun battery bank"
	desc = "A heavy reinforced backpack with support equipment and power cells for the M56 Smartgun System."
	icon = 'icons/obj/items/clothing/backpacks.dmi'
	icon_state = "d_marinesatch_techi"
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	w_class = SIZE_HUGE
	var/obj/item/cell/pcell = null
	var/reloading = 0


/obj/item/plasmagun_powerpack/New()
	..()
	pcell = new /obj/item/cell/hydrogen_fuel_cell(src)



/obj/item/plasmagun_powerpack/attackby(var/obj/item/A as obj, mob/user as mob)
	if(istype(A,/obj/item/cell))
		var/obj/item/cell/C = A
		visible_message("[user.name] swaps out the power cell in the [src.name].","You swap out the power cell in the [src] and drop the old one.")
		to_chat(user, "The new cell contains: [C.charge] power.")
		pcell.forceMove(get_turf(user))
		pcell = C
		user.drop_inv_item_to_loc(C, src)
		playsound(src,'sound/machines/click.ogg', 25, 1)
	else
		..()

/obj/item/plasmagun_powerpack/examine(mob/user)
	..()
	if (get_dist(user, src) <= 1)
		if(pcell)
			to_chat(user, "A small gauge in the corner reads: Power: [pcell.charge] / [pcell.maxcharge].")

/obj/item/plasmagun_powerpack/proc/drain_powerpack(var/drain = 0, var/obj/item/cell/c)
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

 /// for the gun///


/obj/item/weapon/gun/rifle/phased_plasma_infantry_gun/able_to_fire(mob/living/user)
	. = ..()
	if(.)
		if(!ishuman(user)) return 0
		var/mob/living/carbon/human/H = user
		if(!skillcheckexplicit(user, SKILL_SPEC_WEAPONS, SKILL_SPEC_ALL))
			to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
			return 0
		if ( !istype(H.belt,/obj/item/plasmagun_powerpack))
			click_empty(H)
			return 0


/obj/item/weapon/gun/rifle/phased_plasma_infantry_gun/Fire(atom/target, mob/living/user, params, reflex = 0, dual_wield)
	if(!powerpack)
		if(!link_powerpack(user))
			click_empty(user)
			unlink_powerpack()
			return


/obj/item/weapon/gun/rifle/phased_plasma_infantry_gun/proc/link_powerpack(/mob/user)
	if(!QDELETED(user) && !QDELETED(user.back))
		if(istype(user.back, /obj/item/plasmagun_powerpack))
			powerpack = user.back
			return TRUE
	return FALSE

/obj/item/weapon/gun/rifle/phased_plasma_infantry_gun/proc/unlink_powerpack()
	powerpack = null

/obj/item/weapon/gun/rifle/phased_plasma_infantry_gun/able_to_fire(mob/living/user)
	. = ..()
	if(.)
		if(!ishuman(user)) return 0
		var/mob/living/carbon/human/H = user
		if(!skillcheckexplicit(user, SKILL_SPEC_WEAPONS, SKILL_SPEC_ALL))
			to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
			return 0
		if ( !istype(H.back,/obj/item/plasmagun_powerpack))
			click_empty(H)
			return 0


/// code reference for the backpack if shouldnt do anything, should just help with stuff



// /obj/item/weapon/gun/smartgun
//	name = "\improper M56B smartgun"
//	desc = "The actual firearm in the 4-piece M56B Smartgun System. Essentially a heavy, mobile machinegun.\nYou may toggle firing restrictions by using a special action."
//	icon_state = "m56"
//	item_state = "m56"

//	fire_sound = "gun_smartgun"
//	fire_rattle	= "gun_smartgun_rattle"
//	reload_sound = 'sound/weapons/handling/gun_sg_reload.ogg'
//	unload_sound = 'sound/weapons/handling/gun_sg_unload.ogg'
//	current_mag = /obj/item/ammo_magazine/smartgun
//	flags_equip_slot = NO_FLAGS
//	w_class = SIZE_HUGE
//	force = 20
//	wield_delay = WIELD_DELAY_FAST
//	aim_slowdown = SLOWDOWN_ADS_SPECIALIST
//	var/powerpack = null
//	ammo = /datum/ammo/bullet/smartgun
//	var/datum/ammo/ammo_primary = /datum/ammo/bullet/smartgun //Toggled ammo type
//	var/datum/ammo/ammo_secondary = /datum/ammo/bullet/smartgun/armor_piercing //Toggled ammo type
//	var/iff_enabled = TRUE //Begin with the safety on.
//	var/secondary_toggled = 0 //which ammo we use
//	var/recoil_compensation = 0
//	var/accuracy_improvement = 0
//	var/auto_fire = 0
//	var/motion_detector = 0
//	var/drain = 11
//	var/range = 7
//	var/angle = 2
//	var/list/angle_list = list(180,135,90,60,30)
//	var/obj/item/device/motiondetector/sg/MD
//	var/long_range_cooldown = 2
//	var/recycletime = 120

//	unacidable = 1
//	indestructible = 1

//	attachable_allowed = list(
//						/obj/item/attachable/smartbarrel,
//						/obj/item/attachable/burstfire_assembly,
//						/obj/item/attachable/flashlight)

//	flags_gun_features = GUN_AUTO_EJECTOR|GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY|GUN_HAS_FULL_AUTO
//	gun_category = GUN_CATEGORY_HEAVY
//	starting_attachment_types = list(/obj/item/attachable/smartbarrel)
//	auto_retrieval_slot = WEAR_J_STORE


// /obj/item/weapon/gun/smartgun/Initialize(mapload, ...)
//	. = ..()
//	ammo_primary = GLOB.ammo_list[ammo_primary]
//	ammo_secondary = GLOB.ammo_list[ammo_secondary]
//	MD = new(src)

// /obj/item/weapon/gun/smartgun/set_gun_attachment_offsets()
//	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 16,"rail_x" = 17, "rail_y" = 18, "under_x" = 22, "under_y" = 14, "stock_x" = 22, "stock_y" = 14)

// /obj/item/weapon/gun/smartgun/set_gun_config_values()
//	..()
//	fire_delay = FIRE_DELAY_TIER_10
//	burst_amount = BURST_AMOUNT_TIER_3
//	burst_delay = FIRE_DELAY_TIER_9
//	fa_delay = FIRE_DELAY_TIER_9
//	fa_scatter_peak = FULL_AUTO_SCATTER_PEAK_TIER_6
//	fa_max_scatter = SCATTER_AMOUNT_TIER_5
//	if(accuracy_improvement)
//		accuracy_mult += HIT_ACCURACY_MULT_TIER_2
//	else
//		accuracy_mult += HIT_ACCURACY_MULT_TIER_1
//	if(recoil_compensation)
//		scatter = SCATTER_AMOUNT_TIER_10
//		recoil = RECOIL_OFF
//	else
//		scatter = SCATTER_AMOUNT_TIER_6
//		recoil = RECOIL_AMOUNT_TIER_3
//	burst_scatter_mult = SCATTER_AMOUNT_TIER_8
//	damage_mult = BASE_BULLET_DAMAGE_MULT

// /obj/item/weapon/gun/smartgun/set_bullet_traits()
//	LAZYADD(traits_to_give, list(
//		BULLET_TRAIT_ENTRY_ID("iff", /datum/element/bullet_trait_iff)
//	))

// /obj/item/weapon/gun/smartgun/examine(mob/user)
//	..()
//	var/rounds = 0
//	if(current_mag && current_mag.current_rounds)
//		rounds = current_mag.current_rounds
//	var/message = "[rounds ? "Ammo counter shows [rounds] round\s remaining." : "It's dry."]"
//	to_chat(user, message)
//	to_chat(user, "The restriction system is [iff_enabled ? "<B>on</b>" : "<B>off</b>"].")

// /obj/item/weapon/gun/smartgun/able_to_fire(mob/living/user)
//	. = ..()
//	if(.)
//		if(!ishuman(user)) return 0
//		var/mob/living/carbon/human/H = user
//		if(!skillcheckexplicit(user, SKILL_SPEC_WEAPONS, SKILL_SPEC_SMARTGUN) && !skillcheckexplicit(user, SKILL_SPEC_WEAPONS, SKILL_SPEC_ALL))
//			to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
//			return 0
//		if ( !istype(H.wear_suit,/obj/item/clothing/suit/storage/marine/smartgunner) || !istype(H.back,/obj/item/smartgun_powerpack))
//			click_empty(H)
//			return 0

// /obj/item/weapon/gun/smartgun/delete_bullet(obj/item/projectile/projectile_to_fire, refund = 0)
//	if(!current_mag)
//		return
//	qdel(projectile_to_fire)
//	if(refund) current_mag.current_rounds++
//	return 1


// /obj/item/weapon/gun/smartgun/Fire(atom/target, mob/living/user, params, reflex = 0, dual_wield)
//	if(!powerpack)
//		if(!link_powerpack(user))
//			click_empty(user)
//			unlink_powerpack()
//			return
//	if(powerpack)
//		var/obj/item/smartgun_powerpack/pp = user.back
//		if(istype(pp))
//			var/obj/item/cell/c = pp.pcell
//			var/d = drain
//			if(flags_gun_features & GUN_BURST_ON)
//				d = drain*burst_amount*1.5
//			if(pp.drain_powerpack(d, c))
//				..()


// /obj/item/weapon/gun/smartgun/proc/link_powerpack(var/mob/user)
//	if(!QDELETED(user) && !QDELETED(user.back))
//		if(istype(user.back, /obj/item/smartgun_powerpack))
//			powerpack = user.back
//			return TRUE
//	return FALSE

///obj/item/weapon/gun/smartgun/proc/unlink_powerpack()
// 	powerpack = null ///
