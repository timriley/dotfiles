#!/usr/bin/env python3

# This script was created with the "basic" environment which does not support
# adding dependencies with pip.

# Taken from https://iterm2.com/python-api/examples/theme.html

import asyncio
import iterm2

async def update(connection, theme):
    # Themes have space-delimited attributes, one of which will be light or dark.
    parts = theme.split(" ")
    if "dark" in parts:
        preset = await iterm2.ColorPreset.async_get(connection, "base16-summerfruit-dark-256")
    else:
        preset = await iterm2.ColorPreset.async_get(connection, "base16-summerfruit-light-256")

    # Update the list of all profiles and iterate over them.
    profiles=await iterm2.PartialProfile.async_query(connection)
    for partial in profiles:
        # Fetch the full profile and then set the color preset in it.
        profile = await partial.async_get_full_profile()
        await profile.async_set_color_preset(preset)

async def main(connection):
    app = await iterm2.async_get_app(connection)
    await update(connection, await app.async_get_variable("effectiveTheme"))
    async with iterm2.VariableMonitor(connection, iterm2.VariableScopes.APP, "effectiveTheme", None) as mon:
        while True:
            # Block until theme changes
            theme = await mon.async_get()
            await update(connection, theme)

iterm2.run_forever(main)
