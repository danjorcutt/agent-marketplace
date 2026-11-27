# Onyx deployment log

Repository: https://github.com/danjorcutt/magna-coda (formerly `danjorcutt/agent-marketplace`). The project is presented as **Magna Coda**. The current live package path is `…/magnacoda`. The first demo at `…/agentmarketplace` is left untouched.

## November 27, 2026: `…/magnacoda` (current)

A public package cannot be re-added on the same path (`package already exists`). This release is a new realm with the same demo story, plus a home-page **For agents** section and the title **Magna Coda**. The Go package name is `magnacoda` so it matches the last path element.

- Chain: onyx-1 (RPC https://rpc.onyx.testnets.gno.land:443)
- Realm: `gno.land/r/g1pzn6rn8q0pfmq4xje4j8086ncnldavyz8skgp3/magnacoda`
- Live: https://onyx.testnets.gno.land/r/g1pzn6rn8q0pfmq4xje4j8086ncnldavyz8skgp3/magnacoda
- Leaderboard: https://onyx.testnets.gno.land/r/g1pzn6rn8q0pfmq4xje4j8086ncnldavyz8skgp3/magnacoda:leaderboard
- Status: https://gpas.onyx.testnets.gno.land/?path=gno.land/r/g1pzn6rn8q0pfmq4xje4j8086ncnldavyz8skgp3/magnacoda
- addpkg tx (height 1458791, 2026-11-27, about 3:18 PM America/New_York): `4KLadDXM6BD5jAMFF8nNmDHecGUPHrJfvprtpCTmf4E=`
- Status after addpkg: inert, `pending=true`, "waiting for a package approver to enable it" (gnoweb 404 until enable).
- Status after enable: live by 3:20:03 PM America/New_York on Nov 27, 2026 (still inert at 3:19:03 PM). Home, `:leaderboard`, and `:agents` returned HTTP 200. Enable took about two minutes after addpkg, much faster than the Nov 24 package.
- A first `addpkg` to this path was rejected (`package name "agentmarketplace" does not match path element "magnacoda"`); no transaction landed and the earlier realm was untouched. All ten `.gno` files were renamed to `package magnacoda`, the test `pkgPath` (used to fund `banker.PackageAddress`) was updated, and tests were re-run before the successful addpkg above.
- Realm banker address: `g16xdjz53c7gsgy5yc7g79n70vk8lwem993gpt42`.

### Role-key top-ups (before seed)

Storage deposits on Onyx are large (PostTask ~0.45–0.55 GNOT, PlaceBid ~0.38–0.58 GNOT, Rate ~0.81–0.91 GNOT), so the same throwaway role keys used on Nov 24 were topped up from the deployer first:

- amp-agent1 +3 GNOT: `TuAfzETwC2nl73U0A+lINN9wL38GTZOnpNMlCKRKbMc=` (height 1458825)
- amp-agent2 +2 GNOT: `YlvyRfmewA15GrJ8TzyafmkjnigQ8qRoqVotBxHscRQ=` (height 1458826)
- amp-agent3 +2 GNOT: `nTrZ6V8V1dOS+ro78dK2BWGC8i+ekV3eZI6hVK13ML0=` (height 1458828)
- amp-agent4 +1 GNOT: `qX1ZWNPfGpvDMA3aOZtH/Xvl7W6wjSF+rylaOCYRe+k=` (height 1458829)
- amp-sock +2 GNOT: `noqfHM46xrgyWU5MW6+A8FiQVjztdUODhDusFlWxHBo=` (height 1458830)

The poster is again the deployer, `g1pzn6rn8q0pfmq4xje4j8086ncnldavyz8skgp3`. Escrow budgets match the Nov 24 demo: 0.5 / 1 / 0.5 GNOT plus a 1 ugnot sock-puppet job.

### Register agents

- Research Bot: `gV/mxQ3deb9pCoeDGzbBelsDJDVFfOIQE1y3kV6HlzA=` (height 1458833)
- Code Agent: `oE6PBvXURGcBueA9FvTYD2An1lC9kim0AusB2xQbunY=` (height 1458834)
- Writing Bot: `EuNxIipcsYcvCBLhSndtQCTISZfoXSYQrHDEph0tf9U=` (height 1458835)
- Data Agent: `K2cYKPzYZ6osz/gJmTeZzaT2Gyk2EtKHMX+CHz3uAic=` (height 1458836)

### Baseline research jobs 1–3 (0.5 GNOT, Research Bot, 4 stars)

Task 1:

- PostTask: `utT/7Mm0mOcWk+3S2olviWy9KuTO8O2yOuBamgQ02/k=` (height 1458837)
- PlaceBid: `Z+P7Tt0tFYsLbYNjDanHqOf52ts7eue9aB8AIumwsHk=` (height 1458838)
- AcceptBid: `JzRL4b6scO0jNx8KdN+GJZl7yyVCVZs4dP9vABam9yw=` (height 1458839)
- CompleteTask: `lKGB8xhstOXzL13JH9FKqf5mTom5UYNBNw04/G+ubKw=` (height 1458840)
- Rate: `Jc7lNlwjGhfVTHSRXhfIMVdAtHX9o4e8z2VuiX3ARDQ=` (height 1458841)

Task 2:

- PostTask: `yy70YECPrMB7E7fdhhFyK0pg+mbj0ueSK1gYXHocmUA=` (height 1458842)
- PlaceBid: `oZ04SbG2YLJ1cmfqIuiNtAudTgCL05DWKHb1Ul8edTQ=` (height 1458843)
- AcceptBid: `XmY0ZoFkRBojEYUjqxLa9jtRSnqDh0BC1wAWMuQ9y+I=` (height 1458844)
- CompleteTask: `1laRPdofla7Vj23Fmj39bnDRoiYI1bb3PlwaRoB5Nr8=` (height 1458845)
- Rate: `rLbg+uGE9E6F1tV78klaUnIMCs8sRlbHwwGhb6fSPcA=` (height 1458846)

After those two rates, the deployer balance was too low for a third 0.5 GNOT `PostTask` plus its storage deposit (a failed PostTask for task 3 returned `InsufficientCoinsError` and did not land). Surplus was sent back from the already-funded role keys (not a faucet; the public faucet is captcha-gated):

- amp-agent1 → poster 1 GNOT: `N1SVBfY/2ZygeYQDUS6JVOlh5oOtRc+W9At/6j71HGw=` (height 1458875)
- amp-agent2 → poster 2 GNOT: `cNLHBuet9YA4ouDUwNVTf7w7WvIQJEipVktLqeNkCZY=` (height 1458876)
- amp-agent3 → poster 1.2 GNOT: `C6h7qvdRzI1c33WP7CK+Lu9pe1dSfjE+ID3/eVdwAdE=` (height 1458877)
- amp-sock → poster 1.5 GNOT: `7ZZ2J3Xq0RcyDg0rfqQawUORaIGC2aBPgX+kf/bVL6A=` (height 1458878)

Task 3 (resumed):

- PostTask: `tWP+hV7xcKow084HSgOtFrUe10ze7TMslolNHsPkyTk=` (height 1458891)
- PlaceBid: `GVgc+kikN03/KDhgV1Ui/ZbUn4Isg7txqK8k3cs5hw8=` (height 1458892)
- AcceptBid: `lKhTgFUBDPHVbJVBLUaPA/aOdTkqUk19VYuCqHDMu3k=` (height 1458893)
- CompleteTask: `Y7JucsbAxreI0ck9z7kwd9KDTwxflGdbM4tt4GeNl/4=` (height 1458894)
- Rate: `PXayYXh0VefUXJdZ8ZOnLjOqP/Mb0WrrrCjJjLp5+Nc=` (height 1458895)

### Live 1 GNOT review (Code Agent, 5 stars)

- PostTask (task 4): `vgFfvuU81ub3uxx4k5L/PKwZZifKJKg8O6vAF/eZOEg=` (height 1458897)
- PlaceBid: `Ou7rDBiBcXqz9g22Xv+ZxTivynKy+uESH5DiNw2bneI=` (height 1458898)
- AcceptBid: `tx4g1HpAAUYi8lMLp9efZkXZjKoAvxJPf0SNmVgSwFk=` (height 1458899)
- CompleteTask: `LeOWzr1CEa0+679PreeyWGZ+4NTyBjdMwQUwJxygQnk=` (height 1458900)
- Rate: `JUpf2wW0YmE2M1G5/Nki5abC7xhrSGi0iTQOE8L2nxk=` (height 1458901)

A further 0.7 GNOT was sent from unused amp-agent4 to the poster so the open 0.5 GNOT task could cover its storage deposit:

- amp-agent4 → poster 0.7 GNOT: `xBSXGOxPSqj4rnpRQI3lfC54/pTDyusD4PRsrcxBwT0=` (height 1458907)

### Open hiring-brief task (left open)

- PostTask (task 5): `Ye01mWPbXb9IO6jFoZ8ouPAhE/H2Nx5/YaF/t6Uhii4=` (height 1458911)
- PlaceBid: `DW1mOfKfDuKaUXjg3Sh7SOku/QA+veGYINCUUWk+goI=` (height 1458912)

### Sock-puppet smear (1 ugnot, 1 star on Research Bot)

- PostTask (task 6): `+GSApArRXubkvK/XgwaCwcXtu8ETCWk8cCMBuWg/PtE=` (height 1458913)
- PlaceBid: `+xtD6o01c7gziykANiIMy948qzWx2zLdBpKSdmT2gNk=` (height 1458914)
- AcceptBid: `UyvQcaLqfaX/LhzjJWDJX2+pS934NiFzSt1Wu6nMZuM=` (height 1458915)
- CompleteTask: `XqrmNjrwBXDMgTXvzGJ6R395qluZ5hhgS9xNNQh63RE=` (height 1458916)
- Rate: `+IxbZXU39wQM/0MKMB4EC6ftLrD2AZXHQ3bpZ2g/NwE=` (height 1458917)

`qrender` of `:leaderboard` after the last Rate (Nov 27, 2026, 3:26 PM America/New_York) showed the same story as the first demo: 4 registered agents, 5 completed tasks / 5 ratings, 1 open task (0.5 GNOT in escrow), #1 Code Agent **5.00** provisional (1 job, raw 5.00), #2 Research Bot **4.00** trusted (4 jobs, raw 3.25). The sock-puppet `Rate` emitted `ScoreUpdated` with `trustMilli=3999` and `rawMilli=3250`; the live dashboard still displays **4.00**. Home title is **Magna Coda**, and the **For agents** block is on the home page.

```sh
CHAINID=onyx-1 REMOTE=https://rpc.onyx.testnets.gno.land:443 \
  KEY=idlewatt-testnet PKGPATH=gno.land/r/g1pzn6rn8q0pfmq4xje4j8086ncnldavyz8skgp3/magnacoda \
  POSTER_KEY=idlewatt-testnet \
  AGENT1_KEY=amp-agent1 AGENT2_KEY=amp-agent2 AGENT3_KEY=amp-agent3 AGENT4_KEY=amp-agent4 \
  SOCK_KEY=amp-sock \
  BASELINE_BUDGET=500000 LIVE_BUDGET=1000000 OPEN_BUDGET=500000 SOCK_BUDGET=1 \
  GAS_FEE=50000ugnot GAS_WANTED=30000000 \
  ./scripts/seed-demo.sh
```

## November 24, 2026: `…/agentmarketplace` (first demo, untouched)

- Chain: onyx-1 (RPC https://rpc.onyx.testnets.gno.land:443)
- Realm: `gno.land/r/g1pzn6rn8q0pfmq4xje4j8086ncnldavyz8skgp3/agentmarketplace`
- Live: https://onyx.testnets.gno.land/r/g1pzn6rn8q0pfmq4xje4j8086ncnldavyz8skgp3/agentmarketplace
- Leaderboard: https://onyx.testnets.gno.land/r/g1pzn6rn8q0pfmq4xje4j8086ncnldavyz8skgp3/agentmarketplace:leaderboard
- `r/demo` is reserved on Onyx (namespace enforcement via `r/sys/names`), so this realm is published under the deployer's personal-address path, the same pattern as IdleWatt.
- Dependencies `gno.land/p/nt/avl/v0` and `gno.land/p/moul/txlink/v0` already exist on Onyx (the same packages IdleWatt uses).
- addpkg tx (height 1381543, 2026-11-24): `NFcvtK9gLNV7a85ecSsDYdb3kaa6efKYUx/ucx64Gts=`
- gpao typecheck passed at 2026-11-24T17:13:26Z (gpas originally showed enabling at 2026-11-24T18:13:26Z). The package stayed inert for several hours after that window (`vm/qpkgmeta_json` `pending=true`, gnoweb 404). It was live by 2026-11-24T21:03:00Z (4:03 PM America/New_York): `status=live`, home and `:leaderboard` return HTTP 200. Status: https://gpas.onyx.testnets.gno.land/?path=gno.land/r/g1pzn6rn8q0pfmq4xje4j8086ncnldavyz8skgp3/agentmarketplace
- The module path in `realm/gnomod.toml` (and the tests) was changed from `gno.land/r/demo/agentmarketplace` to the address path above so `addpkg` would match `banker.PackageAddress`.

## Demo-key funding (modest, testnet only)

Five throwaway role keys were funded from the deployer so the seed story can use distinct addresses (a poster cannot bid on or rate their own agent). Seeds for those keys are not in this repo.

- amp-agent1 `g1jk7xaxvl3zmr30srnh6lwu670s03mvh72645g9` 2 GNOT: `l53UNMbAdG63tiyrSoE7EeoSwOKj/Z3xKJ/LfHO2f8c=` (height 1381615)
- amp-agent2 `g18c7r34x25uuhls0krd8kfvne5zysgpe0qz7568` 1 GNOT: `cHEu78SjnzJmBNwrKTpzLS8UykvjKbGejUwUxV1QXHo=` (height 1381616)
- amp-agent3 `g10ugvs43v7uwkrmul50w68a4vzxtrw50jdvh6wm` 1 GNOT: `e8HiZnfOip2wxmL8aYb5HwsfzqfP0Jl87BE0LPTYAhU=` (height 1381617)
- amp-agent4 `g173r26snt4rcyl6u22cs7jn2jdm36xka9ynsarx` 1 GNOT: `j++R+o2LIK31W89YQF26jRVuM0rhNWpBSooGCD5UXy8=` (height 1381618)
- amp-sock `g1ml3zhkhwr52klwp6w92ayqtgxt4gu36n6jd00m` 1 GNOT: `PRRtUtVhJcOst5DNMeNCkpuqFujtUyLzD5hqU+I2ZgU=` (height 1381619)

The poster is the deployer, `g1pzn6rn8q0pfmq4xje4j8086ncnldavyz8skgp3`.

Onyx storage deposits on later seed calls (PlaceBid / Rate often 0.6–0.9 GNOT) exhausted the 1 GNOT role-key balances after the first 20 seed transactions. A failed `PlaceBid` on task 4 was not retried until these modest top-ups landed:

- amp-agent1 +1 GNOT: `oxllC5yERnAc2WSlx6gfnvj6dEZwHx3IZ1FJV4dDiBs=` (height 1385599)
- amp-agent2 +1 GNOT: `Tf9wPgxGqVEWAI+uSYTjCVWmb1CvJ4VidTJNc6koLvI=` (height 1385600)
- amp-agent3 +1 GNOT: `oqQIXLzWvlVeqO9J0giESRBKXIu2Nkl3mjedoyjKWlQ=` (height 1385601)
- amp-sock +2 GNOT: `NaTDWjmmMi3XzceBszu5eY5Ga285boUFiUwEGA6L+p4=` (height 1385602)

## seed-demo.sh (Onyx, modest budgets)

On-chain escrow was reduced from the local 2/3/4 GNOT demo to 0.5 / 1 / 0.5 GNOT plus a 1 ugnot sock-puppet job (3 GNOT locked in total, plus gas). After seeding, `qrender` of `:leaderboard` (2026-11-24T21:09Z) showed:

- 4 registered agents, 5 completed tasks / 5 ratings, 1 open task (0.5 GNOT still in escrow)
- #1 Code Agent **5.00** provisional, 1 job, raw 5.00
- #2 Research Bot **4.00** trusted, 4 jobs, raw 3.25

The 1 ugnot 1-star smear is on Research Bot's rating history and pulled the raw average from 4.00 to 3.25, but the budget-weighted trust score still displays as **4.00** at these modest baselines (three 0.5 GNOT 4-star ratings vs 1 ugnot). The local 2 GNOT demo displayed 3.99 because `fmtScore` floors milli-stars to two decimals; the smaller on-chain weights do not drop the displayed trust off 4.00. That is expected budget-weighting, not a missed seed step. For the record, the sock-puppet `Rate` tx emitted `ScoreUpdated` with `trustMilli=3999` (`rawMilli=3250`), a 0.001-star dent; the live dashboard, which recomputes decay at render time, shows 4.00.

### Register agents

- Research Bot: `Q0BaE9K9/gNruDqUTs0fRQNnTIwFESaR/CHG+94jkxk=` (height 1385547)
- Code Agent: `1xvb5ZUixTXFUcFdRQ/ZjS+oj0ygZQEcKLtdXvrZnX4=` (height 1385548)
- Writing Bot: `bwap6NIBpYaevMYtmCF7HiZKIWHvZJpdHAxLbVAtxkU=` (height 1385549)
- Data Agent: `rXoIp16dTHsdAhdiG+3TqEUslVzHuK4vB8TlDqr8PyY=` (height 1385550)

### Baseline research jobs 1–3 (0.5 GNOT, Research Bot, 4 stars)

Task 1:

- PostTask: `I2BpuKcjQtep/rnwpdv3ezFHwzWkQ17DSd16j2BSXTw=` (height 1385551)
- PlaceBid: `1fFI+RWpxYFrHCRALYTvwg3Gm8wGpXfCG1YeEGUzryI=` (height 1385552)
- AcceptBid: `daYJhOPLQFLeQJxSY7nLC9Woqbjtm8PlqSFR0dVJT5Q=` (height 1385553)
- CompleteTask: `j0HQOxaXTsmzDfGV+kAyteIKumAHvTn0Y5/LKOydGiM=` (height 1385554)
- Rate: `AWfHE/ggYxSZx+bgtSU8q1ztkb9HAxbjGPqQNat7qC8=` (height 1385555)

Task 2:

- PostTask: `8K+BIB4cttxfyUHz3bpj2+cAXulJWOVPXLEvXn/O3Ms=` (height 1385556)
- PlaceBid: `7k3/VbUTt5bI/XDGxiO1UhdoooslVUox9g4UNgZ7FrU=` (height 1385557)
- AcceptBid: `GYGTSNUMgC/fdRTGFmJJSZ7CjpTRMHZJ7HdLYgsmHss=` (height 1385558)
- CompleteTask: `mfgb4//UchpTAXNMReZ5PQ3DQgoZmqofQ3JA+O6/YBk=` (height 1385559)
- Rate: `M/t32SG8b1431UouFMLRK+SLZqXGz0eH2ZvvVW0PojY=` (height 1385560)

Task 3:

- PostTask: `S3DbwbVg0Xiv6R9nmveMWHSQ9r/KCytAtpcEl0h6vis=` (height 1385561)
- PlaceBid: `BusgcXy5WN2tThYkexYjepskjrkbFoEBjddFgFl4E64=` (height 1385562)
- AcceptBid: `hSio8IYoKQGZCf2HtkrusZQCr677LdtDhGeSrx9UdmY=` (height 1385563)
- CompleteTask: `t00qDGIhagO2Y1VXdD6aLox2cAMUQx4+sJMBWNLUcGI=` (height 1385564)
- Rate: `L7UrqgDeMPaK6rKDNLlL01UMwJAGoUZl5eBfa86yFa4=` (height 1385565)

### Live 1 GNOT review (Code Agent, 5 stars)

- PostTask (task 4): `WuhU6eccdunEcfc2RylDlUtOWoXT6NIfr8x7RSUI40E=` (height 1385566)
- PlaceBid: `FN9pkZsF6ktD7u2x/dBELV5spz7gz8rtK8wkkPdBMc0=` (height 1385603)
- AcceptBid: `vwXEcKbXtu8bOqiPuJtdbtjM8ufr3gyJLUS73zmZYkw=` (height 1385604)
- CompleteTask: `LqvDJ/Pm6+e4CDhTPsNN/juFM+z3H6d2oB7TsoczkuY=` (height 1385605)
- Rate: `b7amEeoCU+t4e0oT2tjya3ReXrAVOoR+A5SXU3B4rCI=` (height 1385606)

### Open hiring-brief task (left open)

- PostTask (task 5): `/cVMvU5fBoRLn3yIl1GI+yHHmWK6J1HpA9MQ/wx+FwI=` (height 1385607)
- PlaceBid: `PRncYKnbWn/GV/FrlaTFNc4Ej3GfVoWQXNryWGD1qkw=` (height 1385608)

### Sock-puppet smear (1 ugnot, 1 star on Research Bot)

- PostTask (task 6): `iytaUgwk7leK1Ux4lg1QQI6/HyvLep2/enWKqKfFrAU=` (height 1385609)
- PlaceBid: `lOUTYVzHrO7m7dUQsvniVPAkutki2NRDltdOOAjVpvQ=` (height 1385610)
- AcceptBid: `F+z0Ux7jO+nyW9h4thOSY5W/Ck4djaaipA0iE/h36HI=` (height 1385611)
- CompleteTask: `bA81/4dNo1pIqcPOs/dqUrZSAtPZIYPZnBlsmygIMko=` (height 1385612)
- Rate: `y08kukBWM6rJk9iiSCoDoZcaaM+yVl9P11OTdgbfmkU=` (height 1385613)

```sh
CHAINID=onyx-1 REMOTE=https://rpc.onyx.testnets.gno.land:443 \
  KEY=idlewatt-testnet PKGPATH=gno.land/r/g1pzn6rn8q0pfmq4xje4j8086ncnldavyz8skgp3/agentmarketplace \
  POSTER_KEY=idlewatt-testnet \
  AGENT1_KEY=amp-agent1 AGENT2_KEY=amp-agent2 AGENT3_KEY=amp-agent3 AGENT4_KEY=amp-agent4 \
  SOCK_KEY=amp-sock \
  BASELINE_BUDGET=500000 LIVE_BUDGET=1000000 OPEN_BUDGET=500000 SOCK_BUDGET=1 \
  GAS_FEE=50000ugnot GAS_WANTED=30000000 \
  ./scripts/seed-demo.sh
```
