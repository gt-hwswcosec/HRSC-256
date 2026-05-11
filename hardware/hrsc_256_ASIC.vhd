library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity hybrid is
  port(
    clk, rst : in  std_logic;

    key       : in  std_logic_vector(255 downto 0);

    -- IV still loaded all at once (96 pins)
    IV : in std_logic_vector(95 downto 0);

    o_vld : out std_logic;
    keystream_bit_out : out std_logic
  );
end hybrid;

architecture encrypt of hybrid is

  type state_type is (setup, run);
  signal state : state_type;

  signal s_reg : std_logic_vector(511 downto 0);
  signal s     : std_logic_vector(511 downto 0);

  signal count : integer range 0 to 127;

begin

  --[BEGIN HYBRID REGISTER LOGIC]--
    s(511) <= s_reg(509);
    s(510) <= s_reg(508);
    s(509) <= s_reg(507);
    s(508) <= s_reg(506);
    s(507) <= s_reg(505);
    s(506) <= s_reg(504);
    s(505) <= s_reg(503);
    s(504) <= s_reg(502);
    s(503) <= s_reg(501);
    s(502) <= s_reg(500);
    s(501) <= s_reg(499);
    s(500) <= s_reg(498);
    s(499) <= s_reg(497);
    s(498) <= s_reg(496);
    s(497) <= s_reg(495);
    s(496) <= s_reg(494);
    s(495) <= s_reg(493);
    s(494) <= s_reg(492);
    s(493) <= s_reg(491);
    s(492) <= s_reg(490);
    s(491) <= s_reg(489);
    s(490) <= s_reg(488);
    s(489) <= s_reg(487);
    s(488) <= s_reg(486);
    s(487) <= s_reg(485);
    s(486) <= s_reg(484);
    s(485) <= s_reg(483);
    s(484) <= s_reg(482);
    s(483) <= s_reg(481);
    s(482) <= s_reg(480);
    s(481) <= s_reg(479);
    s(480) <= s_reg(478);
    s(479) <= s_reg(477);
    s(478) <= s_reg(476);
    s(477) <= s_reg(475);
    s(476) <= s_reg(474);
    s(475) <= s_reg(473);
    s(474) <= s_reg(472);
    s(473) <= s_reg(471);
    s(472) <= s_reg(470);
    s(471) <= s_reg(469);
    s(470) <= (s_reg(468) XOR s_reg(511));
    s(469) <= (s_reg(467) XOR s_reg(510));
    s(468) <= s_reg(466);
    s(467) <= s_reg(465);
    s(466) <= s_reg(464);
    s(465) <= s_reg(463);
    s(464) <= s_reg(462);
    s(463) <= s_reg(461);
    s(462) <= s_reg(460);
    s(461) <= s_reg(459);
    s(460) <= s_reg(458);
    s(459) <= s_reg(457);
    s(458) <= s_reg(456);
    s(457) <= s_reg(455);
    s(456) <= s_reg(454);
    s(455) <= s_reg(453);
    s(454) <= s_reg(452);
    s(453) <= s_reg(451);
    s(452) <= s_reg(450);
    s(451) <= s_reg(449);
    s(450) <= s_reg(448);
    s(449) <= s_reg(447);
    s(448) <= s_reg(446);
    s(447) <= s_reg(445);
    s(446) <= s_reg(444);
    s(445) <= s_reg(443);
    s(444) <= s_reg(442);
    s(443) <= s_reg(441);
    s(442) <= s_reg(440);
    s(441) <= s_reg(439);
    s(440) <= s_reg(438);
    s(439) <= s_reg(437);
    s(438) <= s_reg(436);
    s(437) <= s_reg(435);
    s(436) <= s_reg(434);
    s(435) <= s_reg(433);
    s(434) <= s_reg(432);
    s(433) <= s_reg(431);
    s(432) <= s_reg(430);
    s(431) <= s_reg(429);
    s(430) <= s_reg(428);
    s(429) <= s_reg(427);
    s(428) <= s_reg(426);
    s(427) <= s_reg(425);
    s(426) <= s_reg(424);
    s(425) <= s_reg(423);
    s(424) <= s_reg(422);
    s(423) <= s_reg(421);
    s(422) <= s_reg(420);
    s(421) <= s_reg(419);
    s(420) <= s_reg(418);
    s(419) <= s_reg(417);
    s(418) <= s_reg(416);
    s(417) <= s_reg(415);
    s(416) <= s_reg(414);
    s(415) <= s_reg(413);
    s(414) <= s_reg(412);
    s(413) <= s_reg(411);
    s(412) <= s_reg(410);
    s(411) <= s_reg(409);
    s(410) <= s_reg(408);
    s(409) <= s_reg(407);
    s(408) <= s_reg(406);
    s(407) <= s_reg(405);
    s(406) <= s_reg(404);
    s(405) <= s_reg(403);
    s(404) <= s_reg(402);
    s(403) <= s_reg(401);
    s(402) <= s_reg(400);
    s(401) <= s_reg(399);
    s(400) <= s_reg(398);
    s(399) <= s_reg(397);
    s(398) <= s_reg(396);
    s(397) <= s_reg(395);
    s(396) <= s_reg(394);
    s(395) <= s_reg(393);
    s(394) <= s_reg(392);
    s(393) <= s_reg(391);
    s(392) <= s_reg(390);
    s(391) <= s_reg(389);
    s(390) <= (s_reg(388) XOR s_reg(511));
    s(389) <= (s_reg(387) XOR s_reg(510));
    s(388) <= s_reg(386);
    s(387) <= s_reg(385);
    s(386) <= s_reg(384);
    s(385) <= s_reg(383);
    s(384) <= s_reg(382);
    s(383) <= s_reg(381);
    s(382) <= s_reg(380);
    s(381) <= s_reg(379);
    s(380) <= s_reg(378);
    s(379) <= s_reg(377);
    s(378) <= s_reg(376);
    s(377) <= s_reg(375);
    s(376) <= s_reg(374);
    s(375) <= s_reg(373);
    s(374) <= s_reg(372);
    s(373) <= s_reg(371);
    s(372) <= (s_reg(370) XOR s_reg(511));
    s(371) <= (s_reg(369) XOR s_reg(510));
    s(370) <= s_reg(368);
    s(369) <= s_reg(367);
    s(368) <= s_reg(366);
    s(367) <= s_reg(365);
    s(366) <= s_reg(364);
    s(365) <= s_reg(363);
    s(364) <= s_reg(362);
    s(363) <= s_reg(361);
    s(362) <= s_reg(360);
    s(361) <= s_reg(359);
    s(360) <= s_reg(358);
    s(359) <= s_reg(357);
    s(358) <= s_reg(356);
    s(357) <= s_reg(355);
    s(356) <= s_reg(354);
    s(355) <= s_reg(353);
    s(354) <= s_reg(352);
    s(353) <= s_reg(351);
    s(352) <= s_reg(350);
    s(351) <= s_reg(349);
    s(350) <= s_reg(348);
    s(349) <= s_reg(347);
    s(348) <= s_reg(346);
    s(347) <= s_reg(345);
    s(346) <= s_reg(344);
    s(345) <= s_reg(343);
    s(344) <= s_reg(342);
    s(343) <= s_reg(341);
    s(342) <= s_reg(340);
    s(341) <= s_reg(339);
    s(340) <= s_reg(338);
    s(339) <= s_reg(337);
    s(338) <= s_reg(336);
    s(337) <= s_reg(335);
    s(336) <= s_reg(334);
    s(335) <= s_reg(333);
    s(334) <= s_reg(332);
    s(333) <= s_reg(331);
    s(332) <= s_reg(330);
    s(331) <= s_reg(329);
    s(330) <= s_reg(328);
    s(329) <= s_reg(327);
    s(328) <= s_reg(326);
    s(327) <= s_reg(325);
    s(326) <= s_reg(324);
    s(325) <= s_reg(323);
    s(324) <= s_reg(322);
    s(323) <= s_reg(321);
    s(322) <= s_reg(320);
    s(321) <= s_reg(319);
    s(320) <= s_reg(318);
    s(319) <= s_reg(317);
    s(318) <= s_reg(316);
    s(317) <= s_reg(315);
    s(316) <= s_reg(314);
    s(315) <= s_reg(313);
    s(314) <= s_reg(312);
    s(313) <= s_reg(311);
    s(312) <= s_reg(310);
    s(311) <= s_reg(309);
    s(310) <= s_reg(308);
    s(309) <= s_reg(307);
    s(308) <= s_reg(306);
    s(307) <= s_reg(305);
    s(306) <= s_reg(304);
    s(305) <= (s_reg(511) XOR s_reg(303));
    s(304) <= (s_reg(302) XOR s_reg(510));
    s(303) <= s_reg(301);
    s(302) <= s_reg(300);
    s(301) <= s_reg(299);
    s(300) <= s_reg(298);
    s(299) <= s_reg(297);
    s(298) <= s_reg(296);
    s(297) <= s_reg(295);
    s(296) <= s_reg(294);
    s(295) <= s_reg(293);
    s(294) <= s_reg(292);
    s(293) <= s_reg(291);
    s(292) <= s_reg(290);
    s(291) <= s_reg(289);
    s(290) <= s_reg(288);
    s(289) <= s_reg(287);
    s(288) <= s_reg(286);
    s(287) <= s_reg(285);
    s(286) <= s_reg(284);
    s(285) <= s_reg(283);
    s(284) <= s_reg(282);
    s(283) <= s_reg(281);
    s(282) <= s_reg(280);
    s(281) <= s_reg(279);
    s(280) <= s_reg(278);
    s(279) <= s_reg(277);
    s(278) <= s_reg(276);
    s(277) <= s_reg(275);
    s(276) <= s_reg(274);
    s(275) <= s_reg(273);
    s(274) <= s_reg(272);
    s(273) <= s_reg(271);
    s(272) <= s_reg(270);
    s(271) <= s_reg(269);
    s(270) <= s_reg(268);
    s(269) <= (s_reg(511) XOR s_reg(267));
    s(268) <= (s_reg(266) XOR s_reg(510));
    s(267) <= s_reg(265);
    s(266) <= s_reg(264);
    s(265) <= s_reg(263);
    s(264) <= s_reg(262);
    s(263) <= s_reg(261);
    s(262) <= s_reg(260);
    s(261) <= s_reg(259);
    s(260) <= s_reg(258);
    s(259) <= s_reg(257);
    s(258) <= s_reg(256);
    s(257) <= s_reg(511);
    s(256) <= s_reg(510);
    s(255) <= (s_reg(254) XOR s_reg(252));
    
    s(254) <= (s_reg(251) XOR s_reg(253)) XOR ((s_reg(428) AND s_reg(368) AND s_reg(370)) XOR (s_reg(452) AND s_reg(275) AND s_reg(416) AND s_reg(280)));
    
    s(253) <= (s_reg(250) XOR s_reg(252)) XOR ((s_reg(427) AND s_reg(474)) XOR (s_reg(509) AND s_reg(415) AND s_reg(279) AND s_reg(385)) XOR (s_reg(267) AND s_reg(414)));
    
    s(252) <= (s_reg(249) XOR s_reg(251)) XOR ((s_reg(440) AND s_reg(464)) XOR (s_reg(461) AND s_reg(428) AND s_reg(299) AND s_reg(483)) XOR (s_reg(474) AND s_reg(413) AND s_reg(437)) XOR (s_reg(407) AND s_reg(305)));
    
    s(251) <= (s_reg(250) XOR s_reg(248)) XOR ((s_reg(386) AND s_reg(280)) XOR (s_reg(480) AND s_reg(379) AND s_reg(315) AND s_reg(267)) XOR (s_reg(445) AND s_reg(429) AND s_reg(447) AND s_reg(266)) XOR (s_reg(411) AND s_reg(329) AND s_reg(406)));
    s(250) <= (s_reg(247) XOR s_reg(249));
    
    s(249) <= (s_reg(246) XOR s_reg(248)) XOR ((s_reg(332) AND s_reg(493)) XOR (s_reg(405) AND s_reg(500) AND s_reg(455)) XOR (s_reg(393) AND s_reg(359)));
    
    s(248) <= (s_reg(247) XOR s_reg(245)) XOR ((s_reg(301) AND s_reg(458) AND s_reg(501)) XOR (s_reg(494) AND s_reg(375) AND s_reg(471) AND s_reg(289)));
    s(247) <= (s_reg(246) XOR s_reg(244));
    s(246) <= (s_reg(245) XOR s_reg(243));
    s(245) <= (s_reg(242) XOR s_reg(244));
    s(244) <= (s_reg(241) XOR s_reg(243));
    s(243) <= (s_reg(240) XOR s_reg(242));
    
    s(242) <= (s_reg(241) XOR s_reg(239)) XOR ((s_reg(409) AND s_reg(316) AND s_reg(289) AND s_reg(346)) XOR (s_reg(510) AND s_reg(472) AND s_reg(361) AND s_reg(475)) XOR (s_reg(377) AND s_reg(275) AND s_reg(329)) XOR (s_reg(308) AND s_reg(452)));
    
    s(241) <= (s_reg(240) XOR s_reg(238)) XOR ((s_reg(340) AND s_reg(310) AND s_reg(447)) XOR (s_reg(265) AND s_reg(286) AND s_reg(295)));
    s(240) <= (s_reg(255) XOR s_reg(237) XOR s_reg(239));
    
    s(239) <= (s_reg(236) XOR s_reg(254) XOR s_reg(238)) XOR ((s_reg(451) AND s_reg(326) AND s_reg(406) AND s_reg(317)) XOR (s_reg(502) AND s_reg(415)));
    
    s(238) <= (s_reg(255) XOR s_reg(237) XOR s_reg(235) XOR s_reg(253)) XOR ((s_reg(309) AND s_reg(296)) XOR (s_reg(485) AND s_reg(282) AND s_reg(418)) XOR (s_reg(303) AND s_reg(483)) XOR (s_reg(462) AND s_reg(504) AND s_reg(321)));
    s(237) <= (s_reg(234) XOR s_reg(236));
    s(236) <= (s_reg(235) XOR s_reg(233));
    
    s(235) <= (s_reg(234) XOR s_reg(255) XOR s_reg(232)) XOR ((s_reg(366) AND s_reg(351) AND s_reg(275)) XOR (s_reg(473) AND s_reg(287) AND s_reg(459) AND s_reg(334)) XOR (s_reg(301) AND s_reg(480) AND s_reg(314)) XOR (s_reg(496) AND s_reg(336) AND s_reg(468)));
    s(234) <= (s_reg(231) XOR s_reg(254) XOR s_reg(233));
    s(233) <= (s_reg(255) XOR s_reg(232) XOR s_reg(253) XOR s_reg(230));
    s(232) <= (s_reg(229) XOR s_reg(231));
    s(231) <= (s_reg(228) XOR s_reg(230));
    
    s(230) <= (s_reg(229) XOR s_reg(227)) XOR ((s_reg(416) AND s_reg(389)) XOR (s_reg(270) AND s_reg(469) AND s_reg(382)) XOR (s_reg(429) AND s_reg(394) AND s_reg(278)));
    s(229) <= (s_reg(228) XOR s_reg(226));
    s(228) <= (s_reg(225) XOR s_reg(227));
    
    s(227) <= (s_reg(226) XOR s_reg(224)) XOR ((s_reg(396) AND s_reg(487)) XOR (s_reg(464) AND s_reg(296)));
    
    s(226) <= (s_reg(225) XOR s_reg(223)) XOR ((s_reg(401) AND s_reg(420) AND s_reg(447) AND s_reg(429)) XOR (s_reg(442) AND s_reg(256)) XOR (s_reg(369) AND s_reg(399)));
    s(225) <= (s_reg(222) XOR s_reg(224));
    s(224) <= (s_reg(221) XOR s_reg(223));
    s(223) <= (s_reg(220) XOR s_reg(222));
    s(222) <= (s_reg(221) XOR s_reg(219));
    s(221) <= (s_reg(220) XOR s_reg(218));
    s(220) <= (s_reg(217) XOR s_reg(219));
    
    s(219) <= (s_reg(218) XOR s_reg(216)) XOR ((s_reg(503) AND s_reg(365)) XOR (s_reg(320) AND s_reg(419) AND s_reg(293) AND s_reg(364)) XOR (s_reg(391) AND s_reg(495) AND s_reg(417)));
    
    s(218) <= (s_reg(215) XOR s_reg(217)) XOR ((s_reg(431) AND s_reg(502)) XOR (s_reg(282) AND s_reg(376) AND s_reg(310)) XOR (s_reg(325) AND s_reg(448) AND s_reg(324)) XOR (s_reg(474) AND s_reg(323) AND s_reg(352)));
    
    s(217) <= (s_reg(214) XOR s_reg(216)) XOR ((s_reg(506) AND s_reg(299) AND s_reg(447) AND s_reg(335)) XOR (s_reg(433) AND s_reg(315) AND s_reg(407) AND s_reg(446)) XOR (s_reg(268) AND s_reg(265) AND s_reg(343)));
    s(216) <= (s_reg(213) XOR s_reg(215));
    s(215) <= (s_reg(212) XOR s_reg(214));
    s(214) <= (s_reg(211) XOR s_reg(213));
    s(213) <= (s_reg(212) XOR s_reg(210));
    
    s(212) <= (s_reg(209) XOR s_reg(211)) XOR ((s_reg(435) AND s_reg(427)) XOR (s_reg(332) AND s_reg(322) AND s_reg(457) AND s_reg(329)) XOR (s_reg(415) AND s_reg(288) AND s_reg(332) AND s_reg(463)));
    
    s(211) <= (s_reg(210) XOR s_reg(208)) XOR ((s_reg(439) AND s_reg(495) AND s_reg(475)) XOR (s_reg(440) AND s_reg(266) AND s_reg(511) AND s_reg(358)) XOR (s_reg(381) AND s_reg(484)));
    s(210) <= (s_reg(209) XOR s_reg(207));
    s(209) <= (s_reg(206) XOR s_reg(208));
    s(208) <= (s_reg(205) XOR s_reg(207));
    
    s(207) <= (s_reg(204) XOR s_reg(206)) XOR ((s_reg(429) AND s_reg(364)) XOR (s_reg(506) AND s_reg(318) AND s_reg(282) AND s_reg(313)) XOR (s_reg(377) AND s_reg(435) AND s_reg(332)) XOR (s_reg(337) AND s_reg(369) AND s_reg(277) AND s_reg(415)));
    
    s(206) <= (s_reg(205) XOR s_reg(203)) XOR ((s_reg(452) AND s_reg(356) AND s_reg(294) AND s_reg(417)) XOR (s_reg(491) AND s_reg(290) AND s_reg(332)) XOR (s_reg(294) AND s_reg(453) AND s_reg(329) AND s_reg(319)));
    
    s(205) <= (s_reg(202) XOR s_reg(204)) XOR ((s_reg(411) AND s_reg(332) AND s_reg(265)) XOR (s_reg(481) AND s_reg(294)));
    s(204) <= (s_reg(203) XOR s_reg(201));
    s(203) <= (s_reg(202) XOR s_reg(200));
    s(202) <= (s_reg(199) XOR s_reg(201));
    s(201) <= (s_reg(198) XOR s_reg(200));
    s(200) <= (s_reg(197) XOR s_reg(199));
    s(199) <= (s_reg(198) XOR s_reg(196));
    s(198) <= (s_reg(195) XOR s_reg(197));
    
    s(197) <= (s_reg(196) XOR s_reg(194)) XOR ((s_reg(377) AND s_reg(351) AND s_reg(413) AND s_reg(509)) XOR (s_reg(497) AND s_reg(283) AND s_reg(327) AND s_reg(341)) XOR (s_reg(335) AND s_reg(280) AND s_reg(380)) XOR (s_reg(256) AND s_reg(493) AND s_reg(316)));
    
    s(196) <= (s_reg(195) XOR s_reg(193)) XOR ((s_reg(305) AND s_reg(469) AND s_reg(491)) XOR (s_reg(368) AND s_reg(392) AND s_reg(417)) XOR (s_reg(406) AND s_reg(463)) XOR (s_reg(261) AND s_reg(346)));
    s(195) <= (s_reg(192) XOR s_reg(194));
    
    s(194) <= (s_reg(193) XOR s_reg(191)) XOR ((s_reg(389) AND s_reg(501) AND s_reg(328) AND s_reg(280)) XOR (s_reg(280) AND s_reg(488) AND s_reg(437) AND s_reg(381)) XOR (s_reg(349) AND s_reg(386)));
    s(193) <= (s_reg(190) XOR s_reg(192));
    s(192) <= (s_reg(189) XOR s_reg(191));
    s(191) <= (s_reg(255) XOR s_reg(190) XOR s_reg(188));
    s(190) <= (s_reg(189) XOR s_reg(254) XOR s_reg(187));
    
    s(189) <= (s_reg(255) XOR s_reg(188) XOR s_reg(253) XOR s_reg(186)) XOR ((s_reg(371) AND s_reg(460) AND s_reg(298) AND s_reg(351)) XOR (s_reg(397) AND s_reg(344) AND s_reg(467) AND s_reg(456)) XOR (s_reg(306) AND s_reg(474) AND s_reg(503)));
    s(188) <= (s_reg(185) XOR s_reg(187));
    
    s(187) <= (s_reg(184) XOR s_reg(186)) XOR ((s_reg(268) AND s_reg(378) AND s_reg(280) AND s_reg(440)) XOR (s_reg(412) AND s_reg(474) AND s_reg(266) AND s_reg(492)) XOR (s_reg(329) AND s_reg(360) AND s_reg(318) AND s_reg(478)));
    s(186) <= (s_reg(183) XOR s_reg(185));
    s(185) <= (s_reg(182) XOR s_reg(184));
    s(184) <= (s_reg(183) XOR s_reg(181));
    
    s(183) <= (s_reg(182) XOR s_reg(180)) XOR ((s_reg(421) AND s_reg(371)) XOR (s_reg(313) AND s_reg(464) AND s_reg(340) AND s_reg(439)) XOR (s_reg(315) AND s_reg(382)) XOR (s_reg(365) AND s_reg(347) AND s_reg(440)));
    
    s(182) <= (s_reg(179) XOR s_reg(181)) XOR ((s_reg(283) AND s_reg(505) AND s_reg(284) AND s_reg(406)) XOR (s_reg(350) AND s_reg(436) AND s_reg(402)) XOR (s_reg(479) AND s_reg(454) AND s_reg(413) AND s_reg(407)) XOR (s_reg(455) AND s_reg(278)));
    s(181) <= (s_reg(178) XOR s_reg(180));
    s(180) <= (s_reg(255) XOR s_reg(179) XOR s_reg(177));
    s(179) <= (s_reg(176) XOR s_reg(254) XOR s_reg(178));
    s(178) <= (s_reg(255) XOR s_reg(175) XOR s_reg(253) XOR s_reg(177));
    s(177) <= (s_reg(174) XOR s_reg(176));
    s(176) <= (s_reg(173) XOR s_reg(175));
    s(175) <= (s_reg(174) XOR s_reg(172));
    s(174) <= (s_reg(255) XOR s_reg(173) XOR s_reg(171));
    s(173) <= (s_reg(172) XOR s_reg(254) XOR s_reg(170));
    s(172) <= (s_reg(255) XOR s_reg(253) XOR s_reg(169) XOR s_reg(171));
    s(171) <= (s_reg(168) XOR s_reg(170));
    s(170) <= (s_reg(167) XOR s_reg(169));
    
    s(169) <= (s_reg(168) XOR s_reg(166)) XOR ((s_reg(318) AND s_reg(425)) XOR (s_reg(377) AND s_reg(261)) XOR (s_reg(433) AND s_reg(269)) XOR (s_reg(388) AND s_reg(422) AND s_reg(425)));
    s(168) <= (s_reg(167) XOR s_reg(165));
    s(167) <= (s_reg(164) XOR s_reg(166));
    
    s(166) <= (s_reg(165) XOR s_reg(163)) XOR ((s_reg(419) AND s_reg(325) AND s_reg(364) AND s_reg(335)) XOR (s_reg(508) AND s_reg(408)));
    
    s(165) <= (s_reg(164) XOR s_reg(162)) XOR ((s_reg(338) AND s_reg(397)) XOR (s_reg(260) AND s_reg(489)) XOR (s_reg(474) AND s_reg(408) AND s_reg(476)) XOR (s_reg(359) AND s_reg(349)));
    s(164) <= (s_reg(161) XOR s_reg(163));
    s(163) <= (s_reg(160) XOR s_reg(162));
    s(162) <= (s_reg(159) XOR s_reg(161));
    
    s(161) <= (s_reg(158) XOR s_reg(160)) XOR ((s_reg(396) AND s_reg(500) AND s_reg(387)) XOR (s_reg(391) AND s_reg(329) AND s_reg(378) AND s_reg(480)) XOR (s_reg(476) AND s_reg(396) AND s_reg(496) AND s_reg(347)) XOR (s_reg(430) AND s_reg(418) AND s_reg(463) AND s_reg(258)));
    s(160) <= (s_reg(159) XOR s_reg(157));
    
    s(159) <= (s_reg(158) XOR s_reg(156)) XOR ((s_reg(434) AND s_reg(293) AND s_reg(367) AND s_reg(309)) XOR (s_reg(447) AND s_reg(377) AND s_reg(310) AND s_reg(346)) XOR (s_reg(464) AND s_reg(437)) XOR (s_reg(449) AND s_reg(386) AND s_reg(492)));
    s(158) <= (s_reg(155) XOR s_reg(157));
    s(157) <= (s_reg(154) XOR s_reg(156));
    
    s(156) <= (s_reg(155) XOR s_reg(153)) XOR ((s_reg(344) AND s_reg(494)) XOR (s_reg(456) AND s_reg(269) AND s_reg(330)) XOR (s_reg(333) AND s_reg(348)) XOR (s_reg(355) AND s_reg(369) AND s_reg(311)));
    s(155) <= (s_reg(152) XOR s_reg(154));
    s(154) <= (s_reg(151) XOR s_reg(153));
    s(153) <= (s_reg(152) XOR s_reg(150));
    s(152) <= (s_reg(151) XOR s_reg(149));
    s(151) <= (s_reg(255) XOR s_reg(150));
    s(150) <= (s_reg(254) XOR s_reg(149));
    s(149) <= (s_reg(255) XOR s_reg(253));
    s(148) <= (s_reg(144) XOR s_reg(146));
    s(147) <= (s_reg(143) XOR s_reg(145));
    s(146) <= (s_reg(144) XOR s_reg(142));
    s(145) <= (s_reg(141) XOR s_reg(143));
    s(144) <= (s_reg(142) XOR s_reg(140));
    
    s(143) <= (s_reg(141) XOR s_reg(139)) XOR ((s_reg(229) AND s_reg(205) AND s_reg(231)) XOR (s_reg(248) AND s_reg(220) AND s_reg(228) AND s_reg(166)) XOR (s_reg(176) AND s_reg(155)));
    s(142) <= (s_reg(138) XOR s_reg(140));
    
    s(141) <= (s_reg(137) XOR s_reg(139)) XOR ((s_reg(194) AND s_reg(222) AND s_reg(158)) XOR (s_reg(158) AND s_reg(166) AND s_reg(219) AND s_reg(198)) XOR (s_reg(161) AND s_reg(159) AND s_reg(170)) XOR (s_reg(165) AND s_reg(206)));
    s(140) <= (s_reg(136) XOR s_reg(138));
    
    s(139) <= (s_reg(137) XOR s_reg(135)) XOR ((s_reg(223) AND s_reg(240) AND s_reg(194)) XOR (s_reg(166) AND s_reg(197)) XOR (s_reg(228) AND s_reg(184) AND s_reg(152)) XOR (s_reg(228) AND s_reg(192) AND s_reg(220) AND s_reg(237)));
    s(138) <= (s_reg(134) XOR s_reg(136));
    
    s(137) <= (s_reg(135) XOR s_reg(133)) XOR ((s_reg(163) AND s_reg(216)) XOR (s_reg(254) AND s_reg(218)) XOR (s_reg(176) AND s_reg(171) AND s_reg(160)));
    s(136) <= (s_reg(134) XOR s_reg(132));
    s(135) <= (s_reg(148) XOR s_reg(131) XOR s_reg(133));
    
    s(134) <= (s_reg(147) XOR s_reg(132) XOR s_reg(130)) XOR ((s_reg(205) AND s_reg(194) AND s_reg(220)) XOR (s_reg(202) AND s_reg(159) AND s_reg(175) AND s_reg(185)) XOR (s_reg(160) AND s_reg(184) AND s_reg(231)));
    s(133) <= (s_reg(148) XOR s_reg(146) XOR s_reg(131) XOR s_reg(129));
    s(132) <= (s_reg(128) XOR s_reg(147) XOR s_reg(145) XOR s_reg(130));
    s(131) <= (s_reg(129) XOR s_reg(127));
    s(130) <= (s_reg(128) XOR s_reg(126));
    s(129) <= (s_reg(127) XOR s_reg(125));
    s(128) <= (s_reg(124) XOR s_reg(126));
    s(127) <= (s_reg(123) XOR s_reg(125));
    s(126) <= (s_reg(122) XOR s_reg(124));
    s(125) <= (s_reg(121) XOR s_reg(123));
    s(124) <= (s_reg(122) XOR s_reg(120));
    s(123) <= (s_reg(121) XOR s_reg(119));
    
    s(122) <= (s_reg(118) XOR s_reg(120)) XOR ((s_reg(150) AND s_reg(156)) XOR (s_reg(220) AND s_reg(155)) XOR (s_reg(162) AND s_reg(189) AND s_reg(152) AND s_reg(198)));
    s(121) <= (s_reg(117) XOR s_reg(119));
    
    s(120) <= (s_reg(118) XOR s_reg(116)) XOR ((s_reg(194) AND s_reg(254) AND s_reg(149)) XOR (s_reg(251) AND s_reg(230) AND s_reg(238) AND s_reg(218)));
    s(119) <= (s_reg(115) XOR s_reg(117));
    s(118) <= (s_reg(114) XOR s_reg(116));
    s(117) <= (s_reg(113) XOR s_reg(115));
    s(116) <= (s_reg(112) XOR s_reg(114));
    s(115) <= (s_reg(113) XOR s_reg(111));
    s(114) <= (s_reg(112) XOR s_reg(110));
    
    s(113) <= (s_reg(111) XOR s_reg(109)) XOR ((s_reg(215) AND s_reg(201) AND s_reg(217)) XOR (s_reg(180) AND s_reg(253) AND s_reg(221) AND s_reg(215)) XOR (s_reg(165) AND s_reg(174) AND s_reg(161)) XOR (s_reg(234) AND s_reg(204)));
    s(112) <= (s_reg(108) XOR s_reg(110));
    s(111) <= (s_reg(107) XOR s_reg(109));
    s(110) <= (s_reg(148) XOR s_reg(106) XOR s_reg(108));
    s(109) <= (s_reg(107) XOR s_reg(105) XOR s_reg(147));
    s(108) <= (s_reg(148) XOR s_reg(106) XOR s_reg(146) XOR s_reg(104));
    s(107) <= (s_reg(103) XOR s_reg(105) XOR s_reg(145) XOR s_reg(147));
    s(106) <= (s_reg(148) XOR s_reg(104) XOR s_reg(102));
    s(105) <= (s_reg(103) XOR s_reg(147) XOR s_reg(101));
    s(104) <= (s_reg(148) XOR s_reg(100) XOR s_reg(146) XOR s_reg(102));
    
    s(103) <= (s_reg(147) XOR s_reg(99) XOR s_reg(145) XOR s_reg(101)) XOR ((s_reg(237) AND s_reg(194) AND s_reg(240)) XOR (s_reg(179) AND s_reg(205)) XOR (s_reg(178) AND s_reg(197)));
    s(102) <= (s_reg(98) XOR s_reg(100));
    s(101) <= (s_reg(97) XOR s_reg(99));
    s(100) <= (s_reg(98) XOR s_reg(96));
    
    s(99) <= (s_reg(97) XOR s_reg(95)) XOR ((s_reg(182) AND s_reg(244)) XOR (s_reg(168) AND s_reg(174) AND s_reg(178)) XOR (s_reg(196) AND s_reg(243) AND s_reg(208)) XOR (s_reg(206) AND s_reg(207) AND s_reg(209)));
    
    s(98) <= (s_reg(94) XOR s_reg(96)) XOR ((s_reg(232) AND s_reg(167) AND s_reg(170) AND s_reg(228)) XOR (s_reg(186) AND s_reg(182) AND s_reg(235)) XOR (s_reg(195) AND s_reg(187) AND s_reg(158)) XOR (s_reg(155) AND s_reg(203) AND s_reg(247)));
    s(97) <= (s_reg(93) XOR s_reg(95));
    
    s(96) <= (s_reg(94) XOR s_reg(92)) XOR ((s_reg(198) AND s_reg(165) AND s_reg(231) AND s_reg(240)) XOR (s_reg(195) AND s_reg(229) AND s_reg(221)) XOR (s_reg(231) AND s_reg(244) AND s_reg(185) AND s_reg(177)) XOR (s_reg(205) AND s_reg(183) AND s_reg(239)));
    
    s(95) <= (s_reg(91) XOR s_reg(93)) XOR ((s_reg(171) AND s_reg(162)) XOR (s_reg(180) AND s_reg(178) AND s_reg(250) AND s_reg(156)) XOR (s_reg(190) AND s_reg(189) AND s_reg(169)) XOR (s_reg(179) AND s_reg(239) AND s_reg(171) AND s_reg(176)));
    s(94) <= (s_reg(90) XOR s_reg(92));
    s(93) <= (s_reg(91) XOR s_reg(89));
    s(92) <= (s_reg(90) XOR s_reg(88));
    s(91) <= (s_reg(148) XOR s_reg(89));
    s(90) <= (s_reg(88) XOR s_reg(147));
    s(89) <= (s_reg(148) XOR s_reg(146));
    s(88) <= (s_reg(145) XOR s_reg(147));
    
    s(87) <= (s_reg(82) XOR s_reg(87)) XOR ((s_reg(136) AND s_reg(147) AND s_reg(143) AND s_reg(101)) XOR (s_reg(108) AND s_reg(105)));
    
    s(86) <= (s_reg(81) XOR s_reg(86)) XOR ((s_reg(119) AND s_reg(144) AND s_reg(99) AND s_reg(139)) XOR (s_reg(119) AND s_reg(107) AND s_reg(128)) XOR (s_reg(130) AND s_reg(132)));
    s(85) <= (s_reg(80) XOR s_reg(85));
    s(84) <= (s_reg(84) XOR s_reg(79));
    s(83) <= (s_reg(78) XOR s_reg(83));
    
    s(82) <= (s_reg(82) XOR s_reg(77)) XOR ((s_reg(97) AND s_reg(109) AND s_reg(114) AND s_reg(107)) XOR (s_reg(131) AND s_reg(106)) XOR (s_reg(95) AND s_reg(112) AND s_reg(106)) XOR (s_reg(89) AND s_reg(96)));
    
    s(81) <= (s_reg(76) XOR s_reg(81)) XOR ((s_reg(115) AND s_reg(145) AND s_reg(142)) XOR (s_reg(92) AND s_reg(97) AND s_reg(94)) XOR (s_reg(133) AND s_reg(122) AND s_reg(103)));
    s(80) <= (s_reg(80) XOR s_reg(75));
    s(79) <= (s_reg(74) XOR s_reg(79));
    s(78) <= (s_reg(78) XOR s_reg(73));
    s(77) <= (s_reg(72) XOR s_reg(77));
    s(76) <= (s_reg(76) XOR s_reg(71));
    s(75) <= (s_reg(75) XOR s_reg(70));
    s(74) <= (s_reg(69) XOR s_reg(74));
    
    s(73) <= (s_reg(68) XOR s_reg(73)) XOR ((s_reg(102) AND s_reg(132)) XOR (s_reg(116) AND s_reg(101)) XOR (s_reg(132) AND s_reg(104)));
    s(72) <= (s_reg(67) XOR s_reg(72));
    
    s(71) <= (s_reg(66) XOR s_reg(71)) XOR ((s_reg(129) AND s_reg(141) AND s_reg(137)) XOR (s_reg(108) AND s_reg(148) AND s_reg(122) AND s_reg(114)) XOR (s_reg(111) AND s_reg(128) AND s_reg(139)));
    
    s(70) <= (s_reg(65) XOR s_reg(70)) XOR ((s_reg(91) AND s_reg(96) AND s_reg(141) AND s_reg(125)) XOR (s_reg(100) AND s_reg(94) AND s_reg(95) AND s_reg(93)) XOR (s_reg(116) AND s_reg(136) AND s_reg(90) AND s_reg(103)) XOR (s_reg(126) AND s_reg(125) AND s_reg(100) AND s_reg(106)));
    s(69) <= (s_reg(69) XOR s_reg(64));
    
    s(68) <= (s_reg(63) XOR s_reg(68)) XOR ((s_reg(134) AND s_reg(103)) XOR (s_reg(99) AND s_reg(93)));
    
    s(67) <= (s_reg(62) XOR s_reg(67)) XOR ((s_reg(105) AND s_reg(92) AND s_reg(129)) XOR (s_reg(114) AND s_reg(102) AND s_reg(143) AND s_reg(142)) XOR (s_reg(130) AND s_reg(111) AND s_reg(95) AND s_reg(133)) XOR (s_reg(136) AND s_reg(100) AND s_reg(123) AND s_reg(93)));
    s(66) <= (s_reg(66) XOR s_reg(61));
    s(65) <= (s_reg(60) XOR s_reg(65));
    s(64) <= (s_reg(59) XOR s_reg(87) XOR s_reg(64));
    
    s(63) <= (s_reg(86) XOR s_reg(63) XOR s_reg(87) XOR s_reg(58)) XOR ((s_reg(97) AND s_reg(143)) XOR (s_reg(99) AND s_reg(120) AND s_reg(102) AND s_reg(89)));
    s(62) <= (s_reg(85) XOR s_reg(86) XOR s_reg(87) XOR s_reg(62) XOR s_reg(57));
    s(61) <= (s_reg(84) XOR s_reg(85) XOR s_reg(86) XOR s_reg(87) XOR s_reg(61));
    s(60) <= (s_reg(84) XOR s_reg(83) XOR s_reg(85) XOR s_reg(60) XOR s_reg(86));
    s(59) <= (s_reg(84) XOR s_reg(83) XOR s_reg(59) XOR s_reg(85));
    
    s(58) <= (s_reg(84) XOR s_reg(58) XOR s_reg(83)) XOR ((s_reg(100) AND s_reg(110)) XOR (s_reg(125) AND s_reg(121)));
    s(57) <= (s_reg(83) XOR s_reg(57));
    
    s(56) <= s_reg(50) XOR ((s_reg(85) AND s_reg(67) AND s_reg(66) AND s_reg(78)) XOR (s_reg(67) AND s_reg(72) AND s_reg(68)));
    s(55) <= s_reg(49);
    s(54) <= s_reg(48);
    
    s(53) <= s_reg(47) XOR ((s_reg(87) AND s_reg(70) AND s_reg(62) AND s_reg(64)) XOR (s_reg(68) AND s_reg(57) AND s_reg(85) AND s_reg(63)));
    s(52) <= s_reg(46);
    s(51) <= s_reg(45);
    s(50) <= s_reg(44);
    s(49) <= s_reg(43);
    
    s(48) <= (s_reg(56) XOR s_reg(42)) XOR ((s_reg(61) AND s_reg(65) AND s_reg(70) AND s_reg(78)) XOR (s_reg(84) AND s_reg(87) AND s_reg(72) AND s_reg(75)));
    
    s(47) <= (s_reg(41) XOR s_reg(55)) XOR ((s_reg(67) AND s_reg(63) AND s_reg(81) AND s_reg(84)) XOR (s_reg(57) AND s_reg(59) AND s_reg(67)) XOR (s_reg(68) AND s_reg(78) AND s_reg(65) AND s_reg(79)) XOR (s_reg(71) AND s_reg(85) AND s_reg(66)));
    s(46) <= (s_reg(40) XOR s_reg(54));
    s(45) <= (s_reg(53) XOR s_reg(56) XOR s_reg(39));
    s(44) <= (s_reg(56) XOR s_reg(55) XOR s_reg(52) XOR s_reg(38));
    s(43) <= (s_reg(56) XOR s_reg(55) XOR s_reg(54) XOR s_reg(51));
    s(42) <= (s_reg(53) XOR s_reg(54) XOR s_reg(55));
    s(41) <= (s_reg(53) XOR s_reg(54) XOR s_reg(52));
    
    s(40) <= (s_reg(53) XOR s_reg(52) XOR s_reg(51)) XOR ((s_reg(76) AND s_reg(87) AND s_reg(62)) XOR (s_reg(66) AND s_reg(59) AND s_reg(73) AND s_reg(61)) XOR (s_reg(86) AND s_reg(78) AND s_reg(71) AND s_reg(84)));
    s(39) <= (s_reg(52) XOR s_reg(51));
    s(38) <= s_reg(51);
    
    s(37) <= s_reg(34) XOR ((s_reg(45) AND s_reg(56) AND s_reg(50)) XOR (s_reg(44) AND s_reg(52)) XOR (s_reg(54) AND s_reg(52)));
    
    s(36) <= s_reg(33) XOR ((s_reg(40) AND s_reg(44)) XOR (s_reg(41) AND s_reg(39) AND s_reg(50)));
    s(35) <= s_reg(32);
    s(34) <= s_reg(31);
    s(33) <= s_reg(30);
    s(32) <= s_reg(29);
    
    s(31) <= (s_reg(37) XOR s_reg(28)) XOR ((s_reg(45) AND s_reg(42)) XOR (s_reg(50) AND s_reg(49) AND s_reg(53) AND s_reg(52)) XOR (s_reg(42) AND s_reg(46) AND s_reg(54)) XOR (s_reg(48) AND s_reg(39) AND s_reg(45)));
    
    s(30) <= (s_reg(36) XOR s_reg(27)) XOR ((s_reg(41) AND s_reg(43)) XOR (s_reg(48) AND s_reg(40)) XOR (s_reg(40) AND s_reg(41)) XOR (s_reg(39) AND s_reg(44) AND s_reg(49)));
    s(29) <= (s_reg(26) XOR s_reg(35));
    s(28) <= s_reg(25);
    s(27) <= (s_reg(24) XOR s_reg(37));
    s(26) <= (s_reg(23) XOR s_reg(36) XOR s_reg(37));
    
    s(25) <= (s_reg(36) XOR s_reg(22) XOR s_reg(35)) XOR ((s_reg(55) AND s_reg(45) AND s_reg(44) AND s_reg(51)) XOR (s_reg(49) AND s_reg(47)) XOR (s_reg(40) AND s_reg(51)));
    
    s(24) <= (s_reg(35) XOR s_reg(21)) XOR ((s_reg(53) AND s_reg(52) AND s_reg(44) AND s_reg(41)) XOR (s_reg(46) AND s_reg(42) AND s_reg(49)));
    
    s(23) <= s_reg(37) XOR ((s_reg(56) AND s_reg(50)) XOR (s_reg(38) AND s_reg(45) AND s_reg(55) AND s_reg(40)) XOR (s_reg(56) AND s_reg(40) AND s_reg(46) AND s_reg(54)));
    s(22) <= s_reg(36);
    s(21) <= s_reg(35);
    s(20) <= s_reg(17);
    s(19) <= s_reg(16);
    s(18) <= s_reg(15);
    
    s(17) <= s_reg(14) XOR ((s_reg(37) AND s_reg(33) AND s_reg(31)) XOR (s_reg(22) AND s_reg(35)));
    s(16) <= s_reg(13);
    s(15) <= s_reg(12);
    s(14) <= (s_reg(11) XOR s_reg(20));
    s(13) <= (s_reg(10) XOR s_reg(19) XOR s_reg(20));
    s(12) <= (s_reg(18) XOR s_reg(9) XOR s_reg(19));
    s(11) <= (s_reg(18) XOR s_reg(20) XOR s_reg(8));
    
    s(10) <= (s_reg(19) XOR s_reg(20)) XOR ((s_reg(30) AND s_reg(25) AND s_reg(21)) XOR (s_reg(23) AND s_reg(32)));
    s(9) <= (s_reg(18) XOR s_reg(19));
    
    s(8) <= s_reg(18) XOR ((s_reg(30) AND s_reg(26) AND s_reg(21) AND s_reg(25)) XOR (s_reg(21) AND s_reg(28) AND s_reg(24)) XOR (s_reg(29) AND s_reg(34) AND s_reg(25) AND s_reg(21)));
    
    s(7) <= (s_reg(6) XOR s_reg(4) XOR s_reg(7) XOR s_reg(3)) XOR ((s_reg(17) AND s_reg(19) AND s_reg(20) AND s_reg(14)) XOR (s_reg(15) AND s_reg(8) AND s_reg(13) AND s_reg(18)));
    s(6) <= (s_reg(6) XOR s_reg(5) XOR s_reg(7) XOR s_reg(3));
    
    s(5) <= (s_reg(6) XOR s_reg(5) XOR s_reg(4)) XOR ((s_reg(13) AND s_reg(19) AND s_reg(8) AND s_reg(9)) XOR (s_reg(18) AND s_reg(14) AND s_reg(12) AND s_reg(10)) XOR (s_reg(12) AND s_reg(13) AND s_reg(11) AND s_reg(19)));
    s(4) <= (s_reg(6) XOR s_reg(5));
    
    s(3) <= (s_reg(5) XOR s_reg(4) XOR s_reg(7)) XOR ((s_reg(12) AND s_reg(9) AND s_reg(16) AND s_reg(8)) XOR (s_reg(19) AND s_reg(20)) XOR (s_reg(9) AND s_reg(18) AND s_reg(13) AND s_reg(11)));
    s(2) <= (s_reg(2) XOR s_reg(1) XOR s_reg(0));
    s(1) <= (s_reg(1) XOR s_reg(0));
    s(0) <= (s_reg(2) XOR s_reg(1));
  --[END HYBRID REGISTER LOGIC]--

  process(rst, clk)
  begin
    if (rst = '1') then
      s_reg(511 downto 256) <= key;
      s_reg(255 downto 160) <= IV;
      s_reg(159 downto 0)   <= (others => '1');

      state        <= setup;
      count        <= 0;
      o_vld        <= '0';
	  
	  keystream_bit_out <= '0';

    elsif rising_edge(clk) then
      case state is
        when setup =>
          o_vld <= '0';
		  keystream_bit_out <= '0';
          s_reg <= s;
          if count = 127 then
            state <= run;
            count <= 0;
          else
            count <= count + 1;
          end if;
        when run =>
          o_vld <= '1';
          s_reg <= s;
		  keystream_bit_out <= s_reg(0) xor s_reg(7) xor s_reg(15);

      end case;
    end if;
  end process;

end encrypt;