-- Parallelized version of HRSC-256 (2 keystream bits/clock cycle)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hybrid is
  port(
    clk  : in  std_logic;
    rst  : in  std_logic;

    key_w       : in  std_logic_vector(31 downto 0);
    key_w_valid : in  std_logic;
    IV   : in  std_logic_vector(95 downto 0);

    o_vld : out std_logic;

    -- 2 keystream bits per clock while in RUN:
    --   keystream_bits_out(0) = y(t)
    --   keystream_bits_out(1) = y(t+1)
    keystream_bits_out : out std_logic_vector(1 downto 0)
  );
end hybrid;

architecture encrypt of hybrid is

  type state_type is (load_key, setup, run);
  signal state : state_type;

  signal s_reg : std_logic_vector(511 downto 0);

  -- setup counter counts SETUP CLOCKS (0..63). Each setup clock performs 2 state updates.
  signal setup_clk_count : integer range 0 to 64 := 0;
  
  signal key_word_idx : integer range 0 to 7;

  -- keystream bit function
  function ks(x : std_logic_vector(511 downto 0)) return std_logic is
  begin
    return x(0) xor x(7) xor x(15);
  end function;

  -- Next-state function
  function nxt(x : std_logic_vector(511 downto 0)) return std_logic_vector is
    variable y : std_logic_vector(511 downto 0);
  begin
    y := (others => '0');

    --[BEGIN HYBRID REGISTER LOGIC]--
    y(511) := x(509);
    y(510) := x(508);
    y(509) := x(507);
    y(508) := x(506);
    y(507) := x(505);
    y(506) := x(504);
    y(505) := x(503);
    y(504) := x(502);
    y(503) := x(501);
    y(502) := x(500);
    y(501) := x(499);
    y(500) := x(498);
    y(499) := x(497);
    y(498) := x(496);
    y(497) := x(495);
    y(496) := x(494);
    y(495) := x(493);
    y(494) := x(492);
    y(493) := x(491);
    y(492) := x(490);
    y(491) := x(489);
    y(490) := x(488);
    y(489) := x(487);
    y(488) := x(486);
    y(487) := x(485);
    y(486) := x(484);
    y(485) := x(483);
    y(484) := x(482);
    y(483) := x(481);
    y(482) := x(480);
    y(481) := x(479);
    y(480) := x(478);
    y(479) := x(477);
    y(478) := x(476);
    y(477) := x(475);
    y(476) := x(474);
    y(475) := x(473);
    y(474) := x(472);
    y(473) := x(471);
    y(472) := x(470);
    y(471) := x(469);
    y(470) := (x(468) XOR x(511));
    y(469) := (x(467) XOR x(510));
    y(468) := x(466);
    y(467) := x(465);
    y(466) := x(464);
    y(465) := x(463);
    y(464) := x(462);
    y(463) := x(461);
    y(462) := x(460);
    y(461) := x(459);
    y(460) := x(458);
    y(459) := x(457);
    y(458) := x(456);
    y(457) := x(455);
    y(456) := x(454);
    y(455) := x(453);
    y(454) := x(452);
    y(453) := x(451);
    y(452) := x(450);
    y(451) := x(449);
    y(450) := x(448);
    y(449) := x(447);
    y(448) := x(446);
    y(447) := x(445);
    y(446) := x(444);
    y(445) := x(443);
    y(444) := x(442);
    y(443) := x(441);
    y(442) := x(440);
    y(441) := x(439);
    y(440) := x(438);
    y(439) := x(437);
    y(438) := x(436);
    y(437) := x(435);
    y(436) := x(434);
    y(435) := x(433);
    y(434) := x(432);
    y(433) := x(431);
    y(432) := x(430);
    y(431) := x(429);
    y(430) := x(428);
    y(429) := x(427);
    y(428) := x(426);
    y(427) := x(425);
    y(426) := x(424);
    y(425) := x(423);
    y(424) := x(422);
    y(423) := x(421);
    y(422) := x(420);
    y(421) := x(419);
    y(420) := x(418);
    y(419) := x(417);
    y(418) := x(416);
    y(417) := x(415);
    y(416) := x(414);
    y(415) := x(413);
    y(414) := x(412);
    y(413) := x(411);
    y(412) := x(410);
    y(411) := x(409);
    y(410) := x(408);
    y(409) := x(407);
    y(408) := x(406);
    y(407) := x(405);
    y(406) := x(404);
    y(405) := x(403);
    y(404) := x(402);
    y(403) := x(401);
    y(402) := x(400);
    y(401) := x(399);
    y(400) := x(398);
    y(399) := x(397);
    y(398) := x(396);
    y(397) := x(395);
    y(396) := x(394);
    y(395) := x(393);
    y(394) := x(392);
    y(393) := x(391);
    y(392) := x(390);
    y(391) := x(389);
    y(390) := (x(388) XOR x(511));
    y(389) := (x(387) XOR x(510));
    y(388) := x(386);
    y(387) := x(385);
    y(386) := x(384);
    y(385) := x(383);
    y(384) := x(382);
    y(383) := x(381);
    y(382) := x(380);
    y(381) := x(379);
    y(380) := x(378);
    y(379) := x(377);
    y(378) := x(376);
    y(377) := x(375);
    y(376) := x(374);
    y(375) := x(373);
    y(374) := x(372);
    y(373) := x(371);
    y(372) := (x(370) XOR x(511));
    y(371) := (x(369) XOR x(510));
    y(370) := x(368);
    y(369) := x(367);
    y(368) := x(366);
    y(367) := x(365);
    y(366) := x(364);
    y(365) := x(363);
    y(364) := x(362);
    y(363) := x(361);
    y(362) := x(360);
    y(361) := x(359);
    y(360) := x(358);
    y(359) := x(357);
    y(358) := x(356);
    y(357) := x(355);
    y(356) := x(354);
    y(355) := x(353);
    y(354) := x(352);
    y(353) := x(351);
    y(352) := x(350);
    y(351) := x(349);
    y(350) := x(348);
    y(349) := x(347);
    y(348) := x(346);
    y(347) := x(345);
    y(346) := x(344);
    y(345) := x(343);
    y(344) := x(342);
    y(343) := x(341);
    y(342) := x(340);
    y(341) := x(339);
    y(340) := x(338);
    y(339) := x(337);
    y(338) := x(336);
    y(337) := x(335);
    y(336) := x(334);
    y(335) := x(333);
    y(334) := x(332);
    y(333) := x(331);
    y(332) := x(330);
    y(331) := x(329);
    y(330) := x(328);
    y(329) := x(327);
    y(328) := x(326);
    y(327) := x(325);
    y(326) := x(324);
    y(325) := x(323);
    y(324) := x(322);
    y(323) := x(321);
    y(322) := x(320);
    y(321) := x(319);
    y(320) := x(318);
    y(319) := x(317);
    y(318) := x(316);
    y(317) := x(315);
    y(316) := x(314);
    y(315) := x(313);
    y(314) := x(312);
    y(313) := x(311);
    y(312) := x(310);
    y(311) := x(309);
    y(310) := x(308);
    y(309) := x(307);
    y(308) := x(306);
    y(307) := x(305);
    y(306) := x(304);
    y(305) := (x(511) XOR x(303));
    y(304) := (x(302) XOR x(510));
    y(303) := x(301);
    y(302) := x(300);
    y(301) := x(299);
    y(300) := x(298);
    y(299) := x(297);
    y(298) := x(296);
    y(297) := x(295);
    y(296) := x(294);
    y(295) := x(293);
    y(294) := x(292);
    y(293) := x(291);
    y(292) := x(290);
    y(291) := x(289);
    y(290) := x(288);
    y(289) := x(287);
    y(288) := x(286);
    y(287) := x(285);
    y(286) := x(284);
    y(285) := x(283);
    y(284) := x(282);
    y(283) := x(281);
    y(282) := x(280);
    y(281) := x(279);
    y(280) := x(278);
    y(279) := x(277);
    y(278) := x(276);
    y(277) := x(275);
    y(276) := x(274);
    y(275) := x(273);
    y(274) := x(272);
    y(273) := x(271);
    y(272) := x(270);
    y(271) := x(269);
    y(270) := x(268);
    y(269) := (x(511) XOR x(267));
    y(268) := (x(266) XOR x(510));
    y(267) := x(265);
    y(266) := x(264);
    y(265) := x(263);
    y(264) := x(262);
    y(263) := x(261);
    y(262) := x(260);
    y(261) := x(259);
    y(260) := x(258);
    y(259) := x(257);
    y(258) := x(256);
    y(257) := x(511);
    y(256) := x(510);
    y(255) := (x(254) XOR x(252));
    
    y(254) := (x(251) XOR x(253)) XOR ((x(428) AND x(368) AND x(370)) XOR (x(452) AND x(275) AND x(416) AND x(280)));
    
    y(253) := (x(250) XOR x(252)) XOR ((x(427) AND x(474)) XOR (x(509) AND x(415) AND x(279) AND x(385)) XOR (x(267) AND x(414)));
    
    y(252) := (x(249) XOR x(251)) XOR ((x(440) AND x(464)) XOR (x(461) AND x(428) AND x(299) AND x(483)) XOR (x(474) AND x(413) AND x(437)) XOR (x(407) AND x(305)));
    
    y(251) := (x(250) XOR x(248)) XOR ((x(386) AND x(280)) XOR (x(480) AND x(379) AND x(315) AND x(267)) XOR (x(445) AND x(429) AND x(447) AND x(266)) XOR (x(411) AND x(329) AND x(406)));
    y(250) := (x(247) XOR x(249));
    
    y(249) := (x(246) XOR x(248)) XOR ((x(332) AND x(493)) XOR (x(405) AND x(500) AND x(455)) XOR (x(393) AND x(359)));
    
    y(248) := (x(247) XOR x(245)) XOR ((x(301) AND x(458) AND x(501)) XOR (x(494) AND x(375) AND x(471) AND x(289)));
    y(247) := (x(246) XOR x(244));
    y(246) := (x(245) XOR x(243));
    y(245) := (x(242) XOR x(244));
    y(244) := (x(241) XOR x(243));
    y(243) := (x(240) XOR x(242));
    
    y(242) := (x(241) XOR x(239)) XOR ((x(409) AND x(316) AND x(289) AND x(346)) XOR (x(510) AND x(472) AND x(361) AND x(475)) XOR (x(377) AND x(275) AND x(329)) XOR (x(308) AND x(452)));
    
    y(241) := (x(240) XOR x(238)) XOR ((x(340) AND x(310) AND x(447)) XOR (x(265) AND x(286) AND x(295)));
    y(240) := (x(255) XOR x(237) XOR x(239));
    
    y(239) := (x(236) XOR x(254) XOR x(238)) XOR ((x(451) AND x(326) AND x(406) AND x(317)) XOR (x(502) AND x(415)));
    
    y(238) := (x(255) XOR x(237) XOR x(235) XOR x(253)) XOR ((x(309) AND x(296)) XOR (x(485) AND x(282) AND x(418)) XOR (x(303) AND x(483)) XOR (x(462) AND x(504) AND x(321)));
    y(237) := (x(234) XOR x(236));
    y(236) := (x(235) XOR x(233));
    
    y(235) := (x(234) XOR x(255) XOR x(232)) XOR ((x(366) AND x(351) AND x(275)) XOR (x(473) AND x(287) AND x(459) AND x(334)) XOR (x(301) AND x(480) AND x(314)) XOR (x(496) AND x(336) AND x(468)));
    y(234) := (x(231) XOR x(254) XOR x(233));
    y(233) := (x(255) XOR x(232) XOR x(253) XOR x(230));
    y(232) := (x(229) XOR x(231));
    y(231) := (x(228) XOR x(230));
    
    y(230) := (x(229) XOR x(227)) XOR ((x(416) AND x(389)) XOR (x(270) AND x(469) AND x(382)) XOR (x(429) AND x(394) AND x(278)));
    y(229) := (x(228) XOR x(226));
    y(228) := (x(225) XOR x(227));
    
    y(227) := (x(226) XOR x(224)) XOR ((x(396) AND x(487)) XOR (x(464) AND x(296)));
    
    y(226) := (x(225) XOR x(223)) XOR ((x(401) AND x(420) AND x(447) AND x(429)) XOR (x(442) AND x(256)) XOR (x(369) AND x(399)));
    y(225) := (x(222) XOR x(224));
    y(224) := (x(221) XOR x(223));
    y(223) := (x(220) XOR x(222));
    y(222) := (x(221) XOR x(219));
    y(221) := (x(220) XOR x(218));
    y(220) := (x(217) XOR x(219));
    
    y(219) := (x(218) XOR x(216)) XOR ((x(503) AND x(365)) XOR (x(320) AND x(419) AND x(293) AND x(364)) XOR (x(391) AND x(495) AND x(417)));
    
    y(218) := (x(215) XOR x(217)) XOR ((x(431) AND x(502)) XOR (x(282) AND x(376) AND x(310)) XOR (x(325) AND x(448) AND x(324)) XOR (x(474) AND x(323) AND x(352)));
    
    y(217) := (x(214) XOR x(216)) XOR ((x(506) AND x(299) AND x(447) AND x(335)) XOR (x(433) AND x(315) AND x(407) AND x(446)) XOR (x(268) AND x(265) AND x(343)));
    y(216) := (x(213) XOR x(215));
    y(215) := (x(212) XOR x(214));
    y(214) := (x(211) XOR x(213));
    y(213) := (x(212) XOR x(210));
    
    y(212) := (x(209) XOR x(211)) XOR ((x(435) AND x(427)) XOR (x(332) AND x(322) AND x(457) AND x(329)) XOR (x(415) AND x(288) AND x(332) AND x(463)));
    
    y(211) := (x(210) XOR x(208)) XOR ((x(439) AND x(495) AND x(475)) XOR (x(440) AND x(266) AND x(511) AND x(358)) XOR (x(381) AND x(484)));
    y(210) := (x(209) XOR x(207));
    y(209) := (x(206) XOR x(208));
    y(208) := (x(205) XOR x(207));
    
    y(207) := (x(204) XOR x(206)) XOR ((x(429) AND x(364)) XOR (x(506) AND x(318) AND x(282) AND x(313)) XOR (x(377) AND x(435) AND x(332)) XOR (x(337) AND x(369) AND x(277) AND x(415)));
    
    y(206) := (x(205) XOR x(203)) XOR ((x(452) AND x(356) AND x(294) AND x(417)) XOR (x(491) AND x(290) AND x(332)) XOR (x(294) AND x(453) AND x(329) AND x(319)));
    
    y(205) := (x(202) XOR x(204)) XOR ((x(411) AND x(332) AND x(265)) XOR (x(481) AND x(294)));
    y(204) := (x(203) XOR x(201));
    y(203) := (x(202) XOR x(200));
    y(202) := (x(199) XOR x(201));
    y(201) := (x(198) XOR x(200));
    y(200) := (x(197) XOR x(199));
    y(199) := (x(198) XOR x(196));
    y(198) := (x(195) XOR x(197));
    
    y(197) := (x(196) XOR x(194)) XOR ((x(377) AND x(351) AND x(413) AND x(509)) XOR (x(497) AND x(283) AND x(327) AND x(341)) XOR (x(335) AND x(280) AND x(380)) XOR (x(256) AND x(493) AND x(316)));
    
    y(196) := (x(195) XOR x(193)) XOR ((x(305) AND x(469) AND x(491)) XOR (x(368) AND x(392) AND x(417)) XOR (x(406) AND x(463)) XOR (x(261) AND x(346)));
    y(195) := (x(192) XOR x(194));
    
    y(194) := (x(193) XOR x(191)) XOR ((x(389) AND x(501) AND x(328) AND x(280)) XOR (x(280) AND x(488) AND x(437) AND x(381)) XOR (x(349) AND x(386)));
    y(193) := (x(190) XOR x(192));
    y(192) := (x(189) XOR x(191));
    y(191) := (x(255) XOR x(190) XOR x(188));
    y(190) := (x(189) XOR x(254) XOR x(187));
    
    y(189) := (x(255) XOR x(188) XOR x(253) XOR x(186)) XOR ((x(371) AND x(460) AND x(298) AND x(351)) XOR (x(397) AND x(344) AND x(467) AND x(456)) XOR (x(306) AND x(474) AND x(503)));
    y(188) := (x(185) XOR x(187));
    
    y(187) := (x(184) XOR x(186)) XOR ((x(268) AND x(378) AND x(280) AND x(440)) XOR (x(412) AND x(474) AND x(266) AND x(492)) XOR (x(329) AND x(360) AND x(318) AND x(478)));
    y(186) := (x(183) XOR x(185));
    y(185) := (x(182) XOR x(184));
    y(184) := (x(183) XOR x(181));
    
    y(183) := (x(182) XOR x(180)) XOR ((x(421) AND x(371)) XOR (x(313) AND x(464) AND x(340) AND x(439)) XOR (x(315) AND x(382)) XOR (x(365) AND x(347) AND x(440)));
    
    y(182) := (x(179) XOR x(181)) XOR ((x(283) AND x(505) AND x(284) AND x(406)) XOR (x(350) AND x(436) AND x(402)) XOR (x(479) AND x(454) AND x(413) AND x(407)) XOR (x(455) AND x(278)));
    y(181) := (x(178) XOR x(180));
    y(180) := (x(255) XOR x(179) XOR x(177));
    y(179) := (x(176) XOR x(254) XOR x(178));
    y(178) := (x(255) XOR x(175) XOR x(253) XOR x(177));
    y(177) := (x(174) XOR x(176));
    y(176) := (x(173) XOR x(175));
    y(175) := (x(174) XOR x(172));
    y(174) := (x(255) XOR x(173) XOR x(171));
    y(173) := (x(172) XOR x(254) XOR x(170));
    y(172) := (x(255) XOR x(253) XOR x(169) XOR x(171));
    y(171) := (x(168) XOR x(170));
    y(170) := (x(167) XOR x(169));
    
    y(169) := (x(168) XOR x(166)) XOR ((x(318) AND x(425)) XOR (x(377) AND x(261)) XOR (x(433) AND x(269)) XOR (x(388) AND x(422) AND x(425)));
    y(168) := (x(167) XOR x(165));
    y(167) := (x(164) XOR x(166));
    
    y(166) := (x(165) XOR x(163)) XOR ((x(419) AND x(325) AND x(364) AND x(335)) XOR (x(508) AND x(408)));
    
    y(165) := (x(164) XOR x(162)) XOR ((x(338) AND x(397)) XOR (x(260) AND x(489)) XOR (x(474) AND x(408) AND x(476)) XOR (x(359) AND x(349)));
    y(164) := (x(161) XOR x(163));
    y(163) := (x(160) XOR x(162));
    y(162) := (x(159) XOR x(161));
    
    y(161) := (x(158) XOR x(160)) XOR ((x(396) AND x(500) AND x(387)) XOR (x(391) AND x(329) AND x(378) AND x(480)) XOR (x(476) AND x(396) AND x(496) AND x(347)) XOR (x(430) AND x(418) AND x(463) AND x(258)));
    y(160) := (x(159) XOR x(157));
    
    y(159) := (x(158) XOR x(156)) XOR ((x(434) AND x(293) AND x(367) AND x(309)) XOR (x(447) AND x(377) AND x(310) AND x(346)) XOR (x(464) AND x(437)) XOR (x(449) AND x(386) AND x(492)));
    y(158) := (x(155) XOR x(157));
    y(157) := (x(154) XOR x(156));
    
    y(156) := (x(155) XOR x(153)) XOR ((x(344) AND x(494)) XOR (x(456) AND x(269) AND x(330)) XOR (x(333) AND x(348)) XOR (x(355) AND x(369) AND x(311)));
    y(155) := (x(152) XOR x(154));
    y(154) := (x(151) XOR x(153));
    y(153) := (x(152) XOR x(150));
    y(152) := (x(151) XOR x(149));
    y(151) := (x(255) XOR x(150));
    y(150) := (x(254) XOR x(149));
    y(149) := (x(255) XOR x(253));
    y(148) := (x(144) XOR x(146));
    y(147) := (x(143) XOR x(145));
    y(146) := (x(144) XOR x(142));
    y(145) := (x(141) XOR x(143));
    y(144) := (x(142) XOR x(140));
    
    y(143) := (x(141) XOR x(139)) XOR ((x(229) AND x(205) AND x(231)) XOR (x(248) AND x(220) AND x(228) AND x(166)) XOR (x(176) AND x(155)));
    y(142) := (x(138) XOR x(140));
    
    y(141) := (x(137) XOR x(139)) XOR ((x(194) AND x(222) AND x(158)) XOR (x(158) AND x(166) AND x(219) AND x(198)) XOR (x(161) AND x(159) AND x(170)) XOR (x(165) AND x(206)));
    y(140) := (x(136) XOR x(138));
    
    y(139) := (x(137) XOR x(135)) XOR ((x(223) AND x(240) AND x(194)) XOR (x(166) AND x(197)) XOR (x(228) AND x(184) AND x(152)) XOR (x(228) AND x(192) AND x(220) AND x(237)));
    y(138) := (x(134) XOR x(136));
    
    y(137) := (x(135) XOR x(133)) XOR ((x(163) AND x(216)) XOR (x(254) AND x(218)) XOR (x(176) AND x(171) AND x(160)));
    y(136) := (x(134) XOR x(132));
    y(135) := (x(148) XOR x(131) XOR x(133));
    
    y(134) := (x(147) XOR x(132) XOR x(130)) XOR ((x(205) AND x(194) AND x(220)) XOR (x(202) AND x(159) AND x(175) AND x(185)) XOR (x(160) AND x(184) AND x(231)));
    y(133) := (x(148) XOR x(146) XOR x(131) XOR x(129));
    y(132) := (x(128) XOR x(147) XOR x(145) XOR x(130));
    y(131) := (x(129) XOR x(127));
    y(130) := (x(128) XOR x(126));
    y(129) := (x(127) XOR x(125));
    y(128) := (x(124) XOR x(126));
    y(127) := (x(123) XOR x(125));
    y(126) := (x(122) XOR x(124));
    y(125) := (x(121) XOR x(123));
    y(124) := (x(122) XOR x(120));
    y(123) := (x(121) XOR x(119));
    
    y(122) := (x(118) XOR x(120)) XOR ((x(150) AND x(156)) XOR (x(220) AND x(155)) XOR (x(162) AND x(189) AND x(152) AND x(198)));
    y(121) := (x(117) XOR x(119));
    
    y(120) := (x(118) XOR x(116)) XOR ((x(194) AND x(254) AND x(149)) XOR (x(251) AND x(230) AND x(238) AND x(218)));
    y(119) := (x(115) XOR x(117));
    y(118) := (x(114) XOR x(116));
    y(117) := (x(113) XOR x(115));
    y(116) := (x(112) XOR x(114));
    y(115) := (x(113) XOR x(111));
    y(114) := (x(112) XOR x(110));
    
    y(113) := (x(111) XOR x(109)) XOR ((x(215) AND x(201) AND x(217)) XOR (x(180) AND x(253) AND x(221) AND x(215)) XOR (x(165) AND x(174) AND x(161)) XOR (x(234) AND x(204)));
    y(112) := (x(108) XOR x(110));
    y(111) := (x(107) XOR x(109));
    y(110) := (x(148) XOR x(106) XOR x(108));
    y(109) := (x(107) XOR x(105) XOR x(147));
    y(108) := (x(148) XOR x(106) XOR x(146) XOR x(104));
    y(107) := (x(103) XOR x(105) XOR x(145) XOR x(147));
    y(106) := (x(148) XOR x(104) XOR x(102));
    y(105) := (x(103) XOR x(147) XOR x(101));
    y(104) := (x(148) XOR x(100) XOR x(146) XOR x(102));
    
    y(103) := (x(147) XOR x(99) XOR x(145) XOR x(101)) XOR ((x(237) AND x(194) AND x(240)) XOR (x(179) AND x(205)) XOR (x(178) AND x(197)));
    y(102) := (x(98) XOR x(100));
    y(101) := (x(97) XOR x(99));
    y(100) := (x(98) XOR x(96));
    
    y(99) := (x(97) XOR x(95)) XOR ((x(182) AND x(244)) XOR (x(168) AND x(174) AND x(178)) XOR (x(196) AND x(243) AND x(208)) XOR (x(206) AND x(207) AND x(209)));
    
    y(98) := (x(94) XOR x(96)) XOR ((x(232) AND x(167) AND x(170) AND x(228)) XOR (x(186) AND x(182) AND x(235)) XOR (x(195) AND x(187) AND x(158)) XOR (x(155) AND x(203) AND x(247)));
    y(97) := (x(93) XOR x(95));
    
    y(96) := (x(94) XOR x(92)) XOR ((x(198) AND x(165) AND x(231) AND x(240)) XOR (x(195) AND x(229) AND x(221)) XOR (x(231) AND x(244) AND x(185) AND x(177)) XOR (x(205) AND x(183) AND x(239)));
    
    y(95) := (x(91) XOR x(93)) XOR ((x(171) AND x(162)) XOR (x(180) AND x(178) AND x(250) AND x(156)) XOR (x(190) AND x(189) AND x(169)) XOR (x(179) AND x(239) AND x(171) AND x(176)));
    y(94) := (x(90) XOR x(92));
    y(93) := (x(91) XOR x(89));
    y(92) := (x(90) XOR x(88));
    y(91) := (x(148) XOR x(89));
    y(90) := (x(88) XOR x(147));
    y(89) := (x(148) XOR x(146));
    y(88) := (x(145) XOR x(147));
    
    y(87) := (x(82) XOR x(87)) XOR ((x(136) AND x(147) AND x(143) AND x(101)) XOR (x(108) AND x(105)));
    
    y(86) := (x(81) XOR x(86)) XOR ((x(119) AND x(144) AND x(99) AND x(139)) XOR (x(119) AND x(107) AND x(128)) XOR (x(130) AND x(132)));
    y(85) := (x(80) XOR x(85));
    y(84) := (x(84) XOR x(79));
    y(83) := (x(78) XOR x(83));
    
    y(82) := (x(82) XOR x(77)) XOR ((x(97) AND x(109) AND x(114) AND x(107)) XOR (x(131) AND x(106)) XOR (x(95) AND x(112) AND x(106)) XOR (x(89) AND x(96)));
    
    y(81) := (x(76) XOR x(81)) XOR ((x(115) AND x(145) AND x(142)) XOR (x(92) AND x(97) AND x(94)) XOR (x(133) AND x(122) AND x(103)));
    y(80) := (x(80) XOR x(75));
    y(79) := (x(74) XOR x(79));
    y(78) := (x(78) XOR x(73));
    y(77) := (x(72) XOR x(77));
    y(76) := (x(76) XOR x(71));
    y(75) := (x(75) XOR x(70));
    y(74) := (x(69) XOR x(74));
    
    y(73) := (x(68) XOR x(73)) XOR ((x(102) AND x(132)) XOR (x(116) AND x(101)) XOR (x(132) AND x(104)));
    y(72) := (x(67) XOR x(72));
    
    y(71) := (x(66) XOR x(71)) XOR ((x(129) AND x(141) AND x(137)) XOR (x(108) AND x(148) AND x(122) AND x(114)) XOR (x(111) AND x(128) AND x(139)));
    
    y(70) := (x(65) XOR x(70)) XOR ((x(91) AND x(96) AND x(141) AND x(125)) XOR (x(100) AND x(94) AND x(95) AND x(93)) XOR (x(116) AND x(136) AND x(90) AND x(103)) XOR (x(126) AND x(125) AND x(100) AND x(106)));
    y(69) := (x(69) XOR x(64));
    
    y(68) := (x(63) XOR x(68)) XOR ((x(134) AND x(103)) XOR (x(99) AND x(93)));
    
    y(67) := (x(62) XOR x(67)) XOR ((x(105) AND x(92) AND x(129)) XOR (x(114) AND x(102) AND x(143) AND x(142)) XOR (x(130) AND x(111) AND x(95) AND x(133)) XOR (x(136) AND x(100) AND x(123) AND x(93)));
    y(66) := (x(66) XOR x(61));
    y(65) := (x(60) XOR x(65));
    y(64) := (x(59) XOR x(87) XOR x(64));
    
    y(63) := (x(86) XOR x(63) XOR x(87) XOR x(58)) XOR ((x(97) AND x(143)) XOR (x(99) AND x(120) AND x(102) AND x(89)));
    y(62) := (x(85) XOR x(86) XOR x(87) XOR x(62) XOR x(57));
    y(61) := (x(84) XOR x(85) XOR x(86) XOR x(87) XOR x(61));
    y(60) := (x(84) XOR x(83) XOR x(85) XOR x(60) XOR x(86));
    y(59) := (x(84) XOR x(83) XOR x(59) XOR x(85));
    
    y(58) := (x(84) XOR x(58) XOR x(83)) XOR ((x(100) AND x(110)) XOR (x(125) AND x(121)));
    y(57) := (x(83) XOR x(57));
    
    y(56) := x(50) XOR ((x(85) AND x(67) AND x(66) AND x(78)) XOR (x(67) AND x(72) AND x(68)));
    y(55) := x(49);
    y(54) := x(48);
    
    y(53) := x(47) XOR ((x(87) AND x(70) AND x(62) AND x(64)) XOR (x(68) AND x(57) AND x(85) AND x(63)));
    y(52) := x(46);
    y(51) := x(45);
    y(50) := x(44);
    y(49) := x(43);
    
    y(48) := (x(56) XOR x(42)) XOR ((x(61) AND x(65) AND x(70) AND x(78)) XOR (x(84) AND x(87) AND x(72) AND x(75)));
    
    y(47) := (x(41) XOR x(55)) XOR ((x(67) AND x(63) AND x(81) AND x(84)) XOR (x(57) AND x(59) AND x(67)) XOR (x(68) AND x(78) AND x(65) AND x(79)) XOR (x(71) AND x(85) AND x(66)));
    y(46) := (x(40) XOR x(54));
    y(45) := (x(53) XOR x(56) XOR x(39));
    y(44) := (x(56) XOR x(55) XOR x(52) XOR x(38));
    y(43) := (x(56) XOR x(55) XOR x(54) XOR x(51));
    y(42) := (x(53) XOR x(54) XOR x(55));
    y(41) := (x(53) XOR x(54) XOR x(52));
    
    y(40) := (x(53) XOR x(52) XOR x(51)) XOR ((x(76) AND x(87) AND x(62)) XOR (x(66) AND x(59) AND x(73) AND x(61)) XOR (x(86) AND x(78) AND x(71) AND x(84)));
    y(39) := (x(52) XOR x(51));
    y(38) := x(51);
    
    y(37) := x(34) XOR ((x(45) AND x(56) AND x(50)) XOR (x(44) AND x(52)) XOR (x(54) AND x(52)));
    
    y(36) := x(33) XOR ((x(40) AND x(44)) XOR (x(41) AND x(39) AND x(50)));
    y(35) := x(32);
    y(34) := x(31);
    y(33) := x(30);
    y(32) := x(29);
    
    y(31) := (x(37) XOR x(28)) XOR ((x(45) AND x(42)) XOR (x(50) AND x(49) AND x(53) AND x(52)) XOR (x(42) AND x(46) AND x(54)) XOR (x(48) AND x(39) AND x(45)));
    
    y(30) := (x(36) XOR x(27)) XOR ((x(41) AND x(43)) XOR (x(48) AND x(40)) XOR (x(40) AND x(41)) XOR (x(39) AND x(44) AND x(49)));
    y(29) := (x(26) XOR x(35));
    y(28) := x(25);
    y(27) := (x(24) XOR x(37));
    y(26) := (x(23) XOR x(36) XOR x(37));
    
    y(25) := (x(36) XOR x(22) XOR x(35)) XOR ((x(55) AND x(45) AND x(44) AND x(51)) XOR (x(49) AND x(47)) XOR (x(40) AND x(51)));
    
    y(24) := (x(35) XOR x(21)) XOR ((x(53) AND x(52) AND x(44) AND x(41)) XOR (x(46) AND x(42) AND x(49)));
    
    y(23) := x(37) XOR ((x(56) AND x(50)) XOR (x(38) AND x(45) AND x(55) AND x(40)) XOR (x(56) AND x(40) AND x(46) AND x(54)));
    y(22) := x(36);
    y(21) := x(35);
    y(20) := x(17);
    y(19) := x(16);
    y(18) := x(15);
    
    y(17) := x(14) XOR ((x(37) AND x(33) AND x(31)) XOR (x(22) AND x(35)));
    y(16) := x(13);
    y(15) := x(12);
    y(14) := (x(11) XOR x(20));
    y(13) := (x(10) XOR x(19) XOR x(20));
    y(12) := (x(18) XOR x(9) XOR x(19));
    y(11) := (x(18) XOR x(20) XOR x(8));
    
    y(10) := (x(19) XOR x(20)) XOR ((x(30) AND x(25) AND x(21)) XOR (x(23) AND x(32)));
    y(9) := (x(18) XOR x(19));
    
    y(8) := x(18) XOR ((x(30) AND x(26) AND x(21) AND x(25)) XOR (x(21) AND x(28) AND x(24)) XOR (x(29) AND x(34) AND x(25) AND x(21)));
    
    y(7) := (x(6) XOR x(4) XOR x(7) XOR x(3)) XOR ((x(17) AND x(19) AND x(20) AND x(14)) XOR (x(15) AND x(8) AND x(13) AND x(18)));
    y(6) := (x(6) XOR x(5) XOR x(7) XOR x(3));
    
    y(5) := (x(6) XOR x(5) XOR x(4)) XOR ((x(13) AND x(19) AND x(8) AND x(9)) XOR (x(18) AND x(14) AND x(12) AND x(10)) XOR (x(12) AND x(13) AND x(11) AND x(19)));
    y(4) := (x(6) XOR x(5));
    
    y(3) := (x(5) XOR x(4) XOR x(7)) XOR ((x(12) AND x(9) AND x(16) AND x(8)) XOR (x(19) AND x(20)) XOR (x(9) AND x(18) AND x(13) AND x(11)));
    y(2) := (x(2) XOR x(1) XOR x(0));
    y(1) := (x(1) XOR x(0));
    y(0) := (x(2) XOR x(1));
    --[END HYBRID REGISTER LOGIC]--

    return y;
  end function;

begin

  -----------------------------------------------------------------------------
  -- Parallelized 2-bit/cycle engine
  -- - RUN: outputs ks(state) and ks(next(state)) each clock
  -- - SETUP: performs 2 state updates per clock so the setup counter goes 0..63
  -----------------------------------------------------------------------------
  process(clk, rst)
    variable s1, s2 : std_logic_vector(511 downto 0);
    variable y0, y1 : std_logic;
  begin
    if rst = '1' then
      -- init state
      state        <= load_key;
      key_word_idx <= 0;
	  s_reg(511 downto 256) <= (others => '0'); -- key bits will be loaded here in the load_key state
      s_reg(255 downto 160)  <= IV;
      s_reg(159 downto 0)    <= (others => '1');
      setup_clk_count <= 0;

      o_vld <= '0';
      keystream_bits_out <= (others => '0');

    elsif rising_edge(clk) then
      case state is
	    when load_key => -- do not clock the 512-bit register in this state
		  o_vld <= '0';
		  -- freeze cipher updates while loading key
          if key_w_valid = '1' then
            -- word0 goes to [511:480], word7 goes to [287:256]
            s_reg(511 - 32*key_word_idx downto 480 - 32*key_word_idx) <= key_w;

            if key_word_idx = 7 then
              state        <= setup;
              key_word_idx <= 0;
              setup_clk_count        <= 0;
            else
              key_word_idx <= key_word_idx + 1;
            end if;
          end if;
        when setup =>
          o_vld <= '0';
          keystream_bits_out <= (others => '0');
		  -- compute 2-step unroll from the current registered state
		  s1 := nxt(s_reg);  -- state after 1 update
		  s2 := nxt(s1);     -- state after 2 updates
          -- perform 2 updates per setup clock
          s_reg <= s2;

          -- count SETUP CLOCKS, not steps: 64 clocks = 128 updates
          if setup_clk_count = 63 then
            state <= run;
            setup_clk_count <= 0;
          else
            setup_clk_count <= setup_clk_count + 1;
          end if;

        when run =>
		  -- compute 2-step unroll from the current registered state
		  s1 := nxt(s_reg);  -- state after 1 update
		  s2 := nxt(s1);     -- state after 2 updates
		  
          -- output two consecutive keystream bits based on state and next-state
          y0 := ks(s_reg); -- bit at time t
          y1 := ks(s1);    -- bit at time t+1

          o_vld <= '1';
          keystream_bits_out(0) <= y0;
          keystream_bits_out(1) <= y1;

          -- advance 2 steps per clock
          s_reg <= s2;
      end case;
    end if;
  end process;

end encrypt;
