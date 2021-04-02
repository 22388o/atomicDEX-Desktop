/******************************************************************************
 * Copyright © 2013-2021 The Komodo Platform Developers.                      *
 *                                                                            *
 * See the AUTHORS, DEVELOPER-AGREEMENT and LICENSE files at                  *
 * the top-level directory of this distribution for the individual copyright  *
 * holder information and the developer policies on copyright and licensing.  *
 *                                                                            *
 * Unless otherwise agreed in a custom licensing agreement, no part of the    *
 * Komodo Platform software, including this file may be copied, modified,     *
 * propagated or distributed except according to the terms contained in the   *
 * LICENSE file                                                               *
 *                                                                            *
 * Removal or modification of this copyright notice is prohibited.            *
 *                                                                            *
 ******************************************************************************/

#pragma once

namespace atomic_dex
{
    constexpr const char*
    get_version()
    {
        return "0.4.0-beta-test-self-update"; // Temporary name for self update feature. TODO: Fix it when feature is complete.
    }
    
    constexpr int
    get_num_version() noexcept
    {
        return 39; // Temporary value for self update feature. TODO: Fix it when feature is complete.
    }

    constexpr const char*
    get_raw_version()
    {
        return "0.4.0";
    }

    constexpr const char*
    get_precedent_raw_version()
    {
        return "0.3.1";
    }
} // namespace atomic_dex
